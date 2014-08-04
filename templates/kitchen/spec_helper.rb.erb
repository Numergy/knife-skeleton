# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
#

require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

begin
  require 'rspec_junit_formatter'
rescue LoadError
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new.install('rspec_junit_formatter')
  require 'rspec_junit_formatter'
end

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
  end
  c.path = '/sbin:/usr/sbin:/usr/bin:/bin'
  c.add_formatter 'RspecJunitFormatter', '/tmp/kitchen.xml'
end
