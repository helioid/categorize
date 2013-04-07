require File.join(File.dirname(__FILE__), '..', 'utils', 'grams')

class BagOfWords
  include ::Utils::Grams

  # DEBUG = false
  # TODO: some gradient descent to choose this number
  # 0 <= MIN_SUPP <= 1, we like 0.01 <= MIN_SUPP <= 0.1
  MIN_SUPP_L = 0.07
  MIN_SUPP_H = 0.1
  NUM_TOP_GRAMS = 250
  MAX_BUCKETS = 8

  # function worst case
  # O(2 x (#frequent_grams x #gram_collections) + #all_grams + MAX_BUCKETS x #gram_collections)
  def model(query, records_to_tokens)
    @gram_cover_cache = {}
    @gram_collections, @all_grams = create_grams(query, records_to_tokens)

    top_grams = determine_frequency_term_sets(@all_grams, query)
    top_grams = top_grams.keys.sort do |gram_c1, gram_c2|
      top_grams[gram_c1] <=> top_grams[gram_c2]
    end.first(MAX_BUCKETS)

    # below block, worst case O(MAX_BUCKETS x #gram_collections)
    @gram_collections.inject({}) do |buckets, gram_collection|
      max_fitness = 0
      max_fit = nil
      top_grams.each do |top_gram|
        # the >= removes the 'none' possibility
        if gram_collection.fitness[top_gram] && gram_collection.fitness[top_gram] >= max_fitness
          max_fitness = gram_collection.fitness[top_gram]
          max_fit = top_gram
        end
      end
      buckets[max_fit] ||= []
      buckets[max_fit] << gram_collection.content
      buckets
    end
  end

  # ==== Return
  # Hash - fitness => [gram_collection, ...]
  # function worst case O(2 x (#frequent_grams x #gram_collections) + #all_grams)
  def determine_frequency_term_sets(all_grams, query)
    # only count a result if it has non-0 words length
    effective_length = @gram_collections.reject do |result|
      result.grams.nil? || result.grams.empty?
    end.length
    
    min_cover_l = MIN_SUPP_L * effective_length 
    # min_cover_h = MIN_SUPP_H * effective_length 

    # for speed only look at top N grams
    # below block, worst case O(#all_grams)
    frequent_grams = all_grams.sort do |gram1, gram2|
      gram2.frequency <=> gram1.frequency
    end.first(NUM_TOP_GRAMS)

    # below block, worst case O(#frequent_grams x #gram_collections)
    frequent_grams = frequent_grams.delete_if do |gram|
      !cover(gram, min_cover_l)
    end

    # below block, worst case O(#frequent_grams x #gram_collections)
    @gram_collections.inject(Hash.new(0)) do |top_grams, gram_collection|
      max_fitness = 0
      max_fit = nil

      frequent_grams.each do |gram|
        fitness = gram_collection.fitness[gram.content] = (gram_collection.content_to_frequency[gram.content] || 0) / gram.frequency.to_f
        if fitness > max_fitness
          max_fitness = fitness
          max_fit = gram.content
        end
      end

      # puts "#{max_fit}: #{max_fitness}"# if DEBUG
      top_grams[max_fit] += 1 if max_fit
      top_grams
    end
  end

  # function worstcase O(#gram_collections)
  def cover(gram, min_length)
    ((cached = @gram_cover_cache[gram]) != nil) and return cached
    count = 0
    @gram_collections.each do |gram_collection|
      frequency = gram_collection.content_to_frequency[gram.content]
      if !frequency.nil? && frequency > 0
        count += 1
        return @gram_cover_cache[gram] = true if count >= min_length
      end
    end
    @gram_cover_cache[gram] = false
  end
end
