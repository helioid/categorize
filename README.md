[![Build Status](https://travis-ci.org/helioid/categorize.png?branch=master)](https://travis-ci.org/helioid/categorize)

# Categorize

**Categorize** is a text categorization library in Ruby.  It prioritizes
performance over accuracy and is built to run online in dynamic web services.

## Installation

**Categorize** is installable as a [Ruby Gem](https://rubygems.org/gems/categorize):
```base
$ gem install categorize
```

## Basic Usage
```ruby
documents = {
  'doc0' => ['lorem', 'ipsum', 'dolor'],
  'doc1' => ['sed', 'perspiciatis', 'unde'],
  'doc2' => ['vero', 'eos', 'accusamus'],
  'doc3' => ['vero', 'eos', 'accusamus', 'iusto', 'odio']
}

Model.make_model('nanotubes', documents)
=> {
  'ipsum'            => ['doc0'],
  'sed perspiciatis' => ['doc1'],
  'vero'             => ['doc2', 'doc3']
}
```

## Modify Model Parameters
```ruby
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

# Use an alternative clustering model.
clusterer = Models::Cluster.new
clusterer.num_clusters = 3

Model.make_model('helioid', documents, clusterer)
=> {
  'floor silicon' => [2],
  'word difficult' => [3],
  'search refinement' => [1, 0, 4]
}

# Use an alternative hierarchical model.
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

## Ownership

Copyright (c) 2013, Helioid Inc. and Peter Lubell-Doughtie. Licensed under the 3-clause BSD License, see file LICENSE for details.
