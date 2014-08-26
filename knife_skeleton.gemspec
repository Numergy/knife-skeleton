# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife_skeleton/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Pierre Rambaud', 'Antoine Rouyer']
  s.email         = ['pierre.rambaud@numergy.com', 'antoine.rouyer@numergy.com']
  s.description   = <<-eos
Knife plugin to create skeleton with rubocop, chefspec, kitchen,
strainer, etc...
eos
  s.summary       = s.description
  s.homepage      = 'https://github.com/Numergy/knife-skeleton'
  s.license       = 'Apache 2.0'

  s.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.executables   = s.files.grep(/^bin\//).map { |f| File.basename(f) }
  s.test_files    = s.files.grep(/^(test|spec|features)\//)
  s.name          = 'knife-skeleton'
  s.require_paths = ['lib']
  s.version       = KnifeSkeleton::VERSION

  s.add_dependency 'chef', '~> 11'
  s.add_dependency 'erubis', '~> 2.7'

  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rubocop', '~> 0.25'
  s.add_development_dependency 'simplecov', '~> 0.9'
  s.add_development_dependency 'fakefs', '>= 0.5.3'
end
