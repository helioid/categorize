#include <inttypes.h> /* intptr_t, PRIxPTR */
#include <search.h> /* hcreate(), hsearch() */
#include <stdio.h>  /* perror(), printf() */
#include <stdlib.h> /* exit() */
#include "ruby.h"

// START header
// For information and references about the module to be stored internally.
VALUE Bow = Qnil;

static VALUE method_model_bow(VALUE, VALUE);
static int add_or_update_gram_from_index(int, char *);

// Store all grams, used in  compare_top_grams.
static char **all_grams_pp;
// END header

// Initialization method for this module.
void Init_bow()
{
  Bow = rb_define_module("Bow");
  rb_define_method(Bow, "model_bow", method_model_bow, 1);
}

const bool DEBUG = false;
const int MAX_BUCKETS = 10;
const float MIN_SUPPORT = 0.1;
const int NUM_TOP_GRAMS = 250;

void fail(const char *message)
{
  perror(message);
  rb_fatal(message);
  exit(1);
}

/*
 * Must hcreate() the hash table before calling fetch() or store().
 *
 * Because p->data is a pointer, fetch() and store() cast between
 * void * and intptr_t.
 */

/* Fetch value from the hash table. */
int fetch(const char *key, intptr_t *value)
{
  ENTRY e = {key: (char *)key}, *p;
  p = hsearch(e, FIND);

  if (p) {
    *value = (intptr_t)p->data;
    return 1;
  } else
    return 0;
}

/* Store key-value pair into the hash table. */
void store(const char *key, intptr_t value)
{
  /*
   * hsearch() may insert a new entry or find an existing entry
   * with the same key. hsearch() ignores e.data if it finds an
   * existing entry. We must call hsearch(), then set p->data.
   */
  ENTRY e = {key: (char *)key}, *p;
  p = hsearch(e, ENTER);

  if (p == NULL) fail("hsearch");

  p->data = (void *)value;
}

char *make_key(int i, char *str)
{
  // Only provide support for < 100 groups.
  int nbuf = (i < 10) ? 3 : 4;
  char *buf = malloc(sizeof(char) * (nbuf + strlen(str)));

  if (buf == NULL) rb_fatal("No memory for key %i", i);

  snprintf(buf, nbuf + strlen(str), "%i_%s", i, str);

  return buf;
}

typedef struct {
  int freq;
  float fitness;
} gram;

int compare_grams(const void *gram1, const void *gram2)
{
  intptr_t g1, g2;

  if (fetch(*(const char **) gram1, &g1) && fetch(*(const char **) gram2, &g2)) {
    return (*(gram *) g2).freq - (*(gram *) g1).freq;
  } else
    fail("compare_grams");

  return 0;
}

int compare_top_grams(const void *idx1, const void *idx2)
{
  char *gram1 = all_grams_pp[*(int *) idx1];
  char *gram2 = all_grams_pp[*(int *) idx2];
  intptr_t g1, g2;

  if (fetch(gram1, &g1) && fetch(gram2, &g2))
    return (*(gram *) g2).fitness - (*(gram *) g1).fitness;
  else
    fail("compare_grams");

  return 0;
}

/*
 * model_bow(array_of_tokens);
 * ==== Return
 * Top terms
 * ==== Parameters
 * array_of_tokens: Tokens to turn into grams and extract phrases from.
 */
static VALUE method_model_bow(VALUE self, VALUE array_of_tokens)
{
  int i, j;
  long array_of_tokens_len = RARRAY_LEN(array_of_tokens);
  int num_grams = 0;

  for (i = 0; i < array_of_tokens_len; i++) {
    // n + n - 1 + n - 2 = 3n - 3 = 3(n - 1)
    // TODO Correct parentheses enclose as (n - 1).
    num_grams += 3 * RARRAY_LEN(rb_ary_entry(array_of_tokens, i)) - 1;
  }

  // Create an empty table that can hold 50 entries.
  if (DEBUG) printf("num grams: %i\n", num_grams);
  if (hcreate(2 * num_grams) == 0)
    fail("hcreate");

  // list of all grams
  all_grams_pp = malloc(sizeof(char *) * num_grams);
  if (all_grams_pp == NULL) rb_fatal("No memory for all_grams_pp");

  int gram_counter = 0;
  char *tmp;
  char *str;
  char *bigram;
  char *trigram;
  char *last_word;
  char *last_2nd_word;
  int non_empty_tokens = 0;
  int tmp_int;

  for (i = 0; i < array_of_tokens_len; i++) {
    // n grams
    last_word = 0;
    last_2nd_word = 0;
    if (DEBUG) printf("start i: %i\n", i);

    for (j = 0; j < RARRAY_LEN(rb_ary_entry(array_of_tokens, i)); j++) {
      VALUE rb_str = rb_ary_entry(rb_ary_entry(array_of_tokens, i), j);
      // store str via malloc so we can free it along with others
      tmp = StringValueCStr(rb_str);
      tmp_int = 1 + strlen(tmp);
      str = malloc(sizeof(char) * tmp_int);
      snprintf(str, tmp_int, "%s", tmp);

      // add gram
      if (add_or_update_gram_from_index(i, str))
        all_grams_pp[gram_counter++] = str;

      if (DEBUG) printf("j: %i, gram: %s", j, str);

      // add bigram
      if (last_word && strcmp(str, last_word) != 0) {
        tmp_int = 2 + strlen(str) + strlen(last_word);
        bigram = malloc(sizeof(char) * tmp_int);

        if (bigram == NULL) rb_fatal("No memory for bigram");
        snprintf(bigram, tmp_int, "%s %s", last_word, str);

        if (add_or_update_gram_from_index(i, bigram))
          all_grams_pp[gram_counter++] = bigram;
        
        if (DEBUG) printf(", bigram: %s", bigram);

        // add trigram
        if (last_2nd_word &&
            strcmp(str, last_word) != 0 &&
            strcmp(str, last_2nd_word) != 0 &&
            strcmp(last_word, last_2nd_word) != 0) {
          tmp_int = 2 + strlen(bigram) + strlen(last_2nd_word);
          trigram = malloc(sizeof(char) * tmp_int);

          if (trigram == NULL) rb_fatal("No memory for trigram");
          snprintf(trigram, tmp_int, "%s %s", last_2nd_word, bigram);

          if (add_or_update_gram_from_index(i, trigram))
            all_grams_pp[gram_counter++] = trigram;
          
          if (DEBUG) printf(", trigram: %s", trigram);
        }
      }
      if (DEBUG) printf("\n");
      last_2nd_word = last_word;
      last_word = str;
    }
    if (j > 0) non_empty_tokens++;
    if (DEBUG) printf("end i: %i\n", i);
  }
  int min_cover = (int) (MIN_SUPPORT * non_empty_tokens);

  if (DEBUG) printf("added %i grams\n", gram_counter);

  // sort all_grams
  qsort(all_grams_pp, gram_counter, sizeof(char *), compare_grams);

  // only consider prominent top NUM_TOP_GRAMS grams
  int num_top_grams = gram_counter < NUM_TOP_GRAMS ? gram_counter : NUM_TOP_GRAMS;

  if (DEBUG) printf("gc %i, ntg %i, atl: %li\n",
                    gram_counter, num_top_grams, array_of_tokens_len);

  int top_grams_p[num_top_grams];

  if (top_grams_p == NULL) rb_fatal("No memory for top_grams_p");

  int top_gram_counter = 0;
  intptr_t g, all_g;
  int count;
  char *key;

  for (i = 0; i < num_top_grams; i++) {
    count = 0;
    for (j = 0; j < array_of_tokens_len; j++) {
      key = make_key(j, all_grams_pp[i]);

      if (fetch(key, &g) && (*(gram *) g).freq > 0 && ++count > min_cover) {
        top_grams_p[top_gram_counter++] = i;
        if (DEBUG) printf("%i: covering gram: %s\n",
                          top_gram_counter - 1, all_grams_pp[i]);
        break;
      }
    }
  }

  if (DEBUG) {
    printf("after top grams\n");
    printf("tgc %i\n", top_gram_counter);
  }

  float max_fitness;
  char *max_fit;

  for (i = 0; i < array_of_tokens_len; i++) {
    if (DEBUG) printf("start i: %i\n", i);

    // set fitness for top grams relative to collections
    for (j = 0; j < top_gram_counter; j++) {
      key = make_key(i, all_grams_pp[top_grams_p[j]]);

      if (fetch(key, &g) && fetch(all_grams_pp[top_grams_p[j]], &all_g)) {
        (*(gram *) g).fitness = (float) (*(gram *) g).freq / (float) (*(gram *) all_g).freq;
        if (DEBUG) printf("fitness %f\n", (*(gram *) g).fitness);
      }

      free(key);
    }

    max_fitness = 0.0;
    max_fit = 0;

    // set fitness for top grams overall
    for (j = 0; j < RARRAY_LEN(rb_ary_entry(array_of_tokens, i)); j++) {
      VALUE rb_str = rb_ary_entry(rb_ary_entry(array_of_tokens, i), j);
      str = StringValueCStr(rb_str);
      key = make_key(i, str);

      if (fetch(key, &g) && (*(gram *) g).fitness > max_fitness) {
        max_fitness = (*(gram *) g).fitness;
        max_fit = str;
      }

      free(key);
      // store fitness of gram
      if (max_fit && fetch(max_fit, &g))
        (*(gram *) g).fitness += 1.0;
    }
  }

  if (DEBUG) printf("after set fitness\n");

  // sort top_grams and take MAX_BUCKETS
  qsort(top_grams_p, top_gram_counter, sizeof(int), compare_top_grams);
  if (DEBUG) printf("after qsort top grams\n");

  int max_fit_idx;
  VALUE term_for_record = rb_ary_new2(array_of_tokens_len);

  for (i = 0; i < array_of_tokens_len; i++) {
    max_fitness = 0;
    max_fit_idx = 0;

    for (j = 0; j < MAX_BUCKETS && j < top_gram_counter; j++) {
      char *key = make_key(i, all_grams_pp[top_grams_p[j]]);

      if (fetch(key, &g) && (*(gram *) g).fitness >= max_fitness) {
        max_fitness = (*(gram *) g).fitness;
        max_fit_idx = j;
      }

      free(key);
    }

    VALUE term = rb_str_new2(all_grams_pp[top_grams_p[max_fit_idx]]);
    rb_ary_push(term_for_record, term);
  }
  if (DEBUG) printf("after qsort top grams\n");
  if (DEBUG) printf("freeing\n");

  for (i = 0; i < gram_counter; i++) {
    for (j = 0; j < array_of_tokens_len; j++) {
      char *key = make_key(j, all_grams_pp[i]);

      if (fetch(key, &g)) free((void *) g);
      free(key);
    }

    fetch(all_grams_pp[i], &g);
    free((void *) g);
    free(all_grams_pp[i]);
  }

  free(all_grams_pp);
  if (DEBUG) printf("freed all grams\n");
  hdestroy();
  if (DEBUG) printf("returning\n");

  return term_for_record;
}

// Return whether gram exists or not
int add_or_update_gram(char *key)
{
  intptr_t g;
  if (fetch(key, &g)) {
    (*(gram *) g).freq += 1;
    if (DEBUG) printf("key: %s, freq: %i\n", key, (*(gram *) g).freq);

    return 0;
  } else {
    gram *g = malloc(sizeof(gram));
    if (g == NULL) rb_fatal("No memory for gram");
    (*g).freq = 1;
    (*g).fitness = 0.0;
    store(key, (intptr_t) g);

    return 1;
  }
}

int add_or_update_gram_from_index(int i, char *str)
{
  char *key = make_key(i, str);
  add_or_update_gram(key);

  return add_or_update_gram(str);
}

