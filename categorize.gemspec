s = Gem::Specification.new do |s|
  s.name         = 'categorize'
  s.version      = '0.0.1'
  s.date         = '2012-06-28'
  s.summary      = 'Text categorization library'
  s.description  = 'Text categorization library'
  s.authors      = ['Peter Lubell-Doughtie', 'Helioid Inc.']
  s.email        = 'peter@helioid.com'
  s.files        = [
    'lib/categorize/model.rb',
    'lib/categorize/constants.rb',
    'lib/categorize/models/bag_of_words.rb',
    'lib/categorize/utils/grams.rb'
  ]
  s.homepage     = 'http://www.helioid.com/'
end

s
