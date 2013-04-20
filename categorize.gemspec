lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'categorize/version'

Gem::Specification.new do |s|
  s.name         = 'categorize'
  s.version      = Categorize::VERSION
  s.platform     = Gem::Platform::RUBY
  s.date         = '2013-04-14'
  s.summary      = 'A text categorization library.'
  s.description  = %q(A text categorization library that favors performance.
                      Built for use in online systems.)
  s.authors      = ['Peter Lubell-Doughtie', 'Helioid Inc.']
  s.email        = 'peter@helioid.com'
  s.files        = Dir.glob('lib/**/*.rb') +
                   Dir.glob('ext/**/*.{c,h,rb}')
  s.extensions   = ['ext/categorize/extconf.rb']
  s.license      = 'BSD3'
  s.homepage     = 'http://www.helioid.com/'
end
