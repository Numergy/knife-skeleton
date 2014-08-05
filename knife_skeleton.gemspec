# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife_skeleton/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Pierre Rambaud']
  s.email         = ['pierre.rambaud@numergy.com']
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

  s.add_dependency 'chef'
  s.add_dependency 'erubis'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'fakefs'
end
