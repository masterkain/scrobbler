# Rakefile

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
#require 'spec/rake/spectask'
 
Dir['tasks/**/*.rake'].each { |rake| load rake }
 
task :default => 'test:unit'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "scrobbler"
    gemspec.summary = "Fork"
    gemspec.description = "Fork"
    gemspec.email = "masterkain@gmail.com"
    gemspec.homepage = "http://github.com/masterkain/scrobbler"
    gemspec.authors = ["xhochy"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end