# encoding: utf-8

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

categories_to_urls = categories.reduce({}) do |a, (category, indices)|
  a[category] = indices.map { |i| urls[i] }
  a
end

puts categories_to_urls

