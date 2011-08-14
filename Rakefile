require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'


namespace :test do

  Rake::TestTask.new(:units) do |t|
    t.pattern = 'test/*_test.rb'
    t.ruby_opts << '-I test'
    t.verbose = true
  end

end
