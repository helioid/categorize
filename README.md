[![Build Status](https://travis-ci.org/helioid/categorize.png?branch=master)](https://travis-ci.org/helioid/categorize)

# Categorize

**Categorize** is a text categorization library written in Ruby.  It
prioritizes performance over accuracy and is built to run online in dynamic web
services.

**Categorize** can be used with multiple models.  Included are a naive
bag-of-words + coverage algorithm, a Ward clustering based algorithm, and a
hierarchical Ward clustering based algoithm.

**Categorize** also includes a C version of the bag-of-words algorithm. This
may give a perfomance boost.  However, it is experimental and should be tested
on the expected document size and length.

## Installation

Install **categorize** as a Ruby [gem](https://rubygems.org/gems/categorize):
```bash
$ gem install categorize
```

### Quick start: web categorization

Install a web search gem:
```bash
$ gem install faroo
```

Run the example search [script](https://github.com/helioid/categorize/blob/master/examples/categorize_search_results.rb), a search for *nanotubes*:
```bash
$ ruby -e "$(curl -fsSL https://raw.github.com/helioid/categorize/master/examples/categorize_search_results.rb)"
```

## Basic Usage
```ruby
require 'categorize'

include Categorize

documents = [
  'lorem ipsum dolor',
  'sed perspiciatis unde',
  'vero eos accusamus',
  'vero eos accusamus iusto odio'
]

Model.make_model('lorem', documents)
=> {
  'ipsum'            => [0],
  'sed perspiciatis' => [1],
  'vero'             => [2, 3]
}
```

## Modify Model Parameters
```ruby
# Helioid search result abstracts as example documents.
documents = [
  %q(Using Helioid search refinement tools you can find and explore what
     you are looking for by interactively narrowing your search results.
     Helioid is a visual search),
  %q(Helioid is a visual search and aggregation tool that enables
     information exploration. Using Helioid's search refinement tools you
     can find.),
  %q(The floor of Silicon Valley is littered with the carcasses of failed
     search startups. Without billions of dollars in resources like
     Microsoft or a tight),
  %q(Dictionary of Difficult Words - helioid. helioid. a. like the sun.
     Find a word. Find a difficult word here. Click on a letter to find
     the word: A B C D E F G H I J K L M N),
  %q(Welcome to the company profile of Helioid on LinkedIn. Using
     Helioid's search refinement tools you can find and explore what
     you're looking for by)
]

bag_of_words = Models::BagOfWords.new

# Customize the parameters for the bag of words model.
bag_of_words.max_buckets = 3
bag_of_words.min_support = 0.4

Model.make_model('helioid', documents, bag_of_words)
=> {
  'refinement tools explore' => [0, 4],
  'helioid visual search' => [1],
  'like' => [2, 3]
}
```

## Use an alternative model.
```ruby
clusterer = Models::Cluster.new
clusterer.num_clusters = 3

Model.make_model('helioid', documents, clusterer)
=> {
  'floor silicon' => [2],
  'word difficult' => [3],
  'search refinement' => [1, 0, 4]
}
```

## Use a hierarchical model.
```ruby
hierarchical_model = Models::HierarchicalCluster.new

Model.make_model('helioid', documents, hierarchical_model)
=> [
  [
    ['search refinement', [3, 2, 1, 0, 4]]
  ],
  [
    ['search refinement', [1, 0, 4]],
    ['word difficult', [3, 2]]
  ],
  [
    ['floor silicon', [2]],
    ['word difficult', [3]],
    ['search refinement', [1, 0, 4]]
  ],
  [
    ['floor silicon', [2]],
    ['word difficult', [3]],
    ['welcome company', [4]],
    ['visual search', [1, 0]]
  ],
  [
    ['search refinement', [0]],
    ['visual search', [1]],
    ['floor silicon', [2]],
    ['word difficult', [3]],
    ['welcome company', [4]]
  ]
]
```

## Use the C version, sometimes it is faster.
```ruby
# It does not take a pivot word.
Model.make_model_c(documents)

=> {
  'ipsum' => [0],
  'sed' => [1],
  'vero eos accusamus' => [2],
  'iusto' => [3]
}
```

## Example: Categorizing search results.

### Install the required gems.
```bash
$ gem install categorize
$ gem install faroo
```

### Ruby code to run as a script or IRB.
```ruby
require 'categorize'
require 'faroo'

query = 'nanotubes'

# Fetch 10 search results.
results = Faroo.new('', 10).web(query)

# Collect the titles.
titles = results.map(&:title)

# Build the categories.
categories = Categorize::Model.make_model(query, titles)

# Unify the documents and the categories.
urls = results.map(&:url)

categories.reduce({}) do |hash, entry|
  category, indices = entry
  hash[category] = indices.map { |i| urls[i] }
  hash
end
=> {
  "encyclopedia" => [
    "http://en.wikipedia.org/wiki/Carbon_nanotube"],
  "modular" => [
    "http://www.flickr.com/photos/fdecomite/5047832096/in/pool-69453349@N00"],
  "yield" => [
    "http://www.abc.net.au/science/articles/2008/01/16/2139711.htm"],
  "circuits" => [
    "http://arstechnica.com/science/news/2012/04/moving-the-heat-around-using-nanotubes.ars"],
  "new" => [
    "http://cleantechnica.com/2012/10/11/new-method-of-fabricating-carbon-nanotubes-is-as-easy-as-writing-with-a-pencil/"],
  "nanowire" => [
    "http://news.cnet.com/Nanowire-or-nanotube-Intel-looks-ahead/2100-1006_3-957709.html"],
  "ibm" => [
    "http://www.computerworld.com/s/article/9232997/IBM_moving_to_replace_silicon_with_carbon_nanotubes_in_computer_chips"],
  "paper" => [
    "http://blogs.discovermagazine.com/80beats/2008/11/05/paper-thin-nanotube-speakers-can-turn-up-the-volume/",
    "http://news.discovery.com/tech/draw-carbon-nanotubes-121012.html",
    "http://dvice.com/archives/2012/11/first-all-carbo.php"]
}
```

The above is included in [`examples/categorize_search_results.rb`](https://github.com/helioid/categorize/blob/master/examples/categorize_search_results.rb).

## Ownership

Copyright (c) 2013, Helioid Inc. and Peter Lubell-Doughtie. Licensed under the 3-clause BSD License, see file LICENSE for details.
