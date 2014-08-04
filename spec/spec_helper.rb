# -*- coding: utf-8 -*-
$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_group 'Knife Skeleton', 'lib/chef'
  add_group 'Skeleton library', 'lib/knife_skeleton'
end
