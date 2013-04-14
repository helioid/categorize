s = Gem::Specification.new do |s|
  s.name         = 'categorize'
  s.version      = '0.0.8'
  s.date         = '2013-04-14'
  s.summary      = 'A text categorization library.'
  s.description  = %q(A text categorization library that favors performance.
                      Built for use in online systems.)
  s.authors      = ['Peter Lubell-Doughtie', 'Helioid Inc.']
  s.email        = 'peter@helioid.com'
  s.files        = %w(
    lib/categorize.rb
    lib/categorize/model.rb
    lib/categorize/constants.rb
    lib/categorize/models/abstract_model.rb
    lib/categorize/models/bag_of_words.rb
    lib/categorize/models/cluster.rb
    lib/categorize/models/hierarchical_cluster.rb
    lib/categorize/utils/gram_collection.rb
    lib/categorize/utils/gram_node.rb
    lib/categorize/utils/grams.rb
  )
  s.homepage     = 'http://www.helioid.com/'
end

s
