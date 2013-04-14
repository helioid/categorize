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
  "doc0" => ["lorem", "ipsum", "dolor"],
  "doc1" => ["sed", "perspiciatis", "unde"],
  "doc2" => ["vero", "eos", "accusamus"],
  "doc3" => ["vero", "eos", "accusamus", "iusto", "odio"]
}

Categorize.make_model('nanotubes', documents)
=> {
  "ipsum"            => ["doc0"],
  "sed perspiciatis" => ["doc1"],
  "vero"             => ["doc2", "doc3"]
}
```

## Ownership

Copyright (c) 2013, Helioid Inc. and Peter Lubell-Doughtie. Licensed under the 3-clause BSD License, see file LICENSE for details.
