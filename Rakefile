require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/extensiontask'
require 'rspec/core'
require 'rspec/core/rake_task'

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'categorize/version'

gem_name = 'categorize'

Rake::ExtensionTask.new(gem_name)

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :spec => [:build, :install]
task :default => :spec

task :build do
  system "gem build #{gem_name}.gemspec"
end

task :install do
  system "gem install #{gem_name}-#{Categorize::VERSION}.gem --no-ri --no-rdoc"
end

task :release do
  system "gem push #{gem_name}-#{Categorize::VERSION}.gem"
end
