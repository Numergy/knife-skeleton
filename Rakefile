# -*- coding: utf-8 -*-
require 'bundler/gem_tasks'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

CLEAN.include 'pkg'

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
end

desc 'Run Rspec tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color --format documentation'
end

task :default => [:rubocop, :spec]
