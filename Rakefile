require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/*_test.rb'
  t.ruby_opts << '-I test'
  t.verbose = true
end
