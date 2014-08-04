# -*- coding: utf-8 -*-
require 'spec_helper'
require 'chef/knife/skeleton'
require 'fakefs/spec_helpers'

describe KnifeSkeleton::SkeletonCreate do
  include FakeFS::SpecHelpers

  before(:each) do
    @knife = KnifeSkeleton::SkeletonCreate.new
    @knife.config = {}
    @knife.name_args = ['foobar']
    @stdout = StringIO.new
    @knife.stub(:stdout).and_return(@stdout)
  end

  describe 'run' do
    it 'should show usage if there is no cookbook name' do
      @knife.config = {}
      @knife.name_args = []
      @knife.ui.should_receive(:fatal).with('You must specify a cookbook name')
      -> { @knife.run }.should raise_error SystemExit
    end

    it 'should raise ArgumentError if there is no cookbook path' do
      @knife.config = { cookbook_path: '' }
      -> { @knife.run }.should raise_error ArgumentError
    end

    it 'should expand the path of the cookbook directory' do
      File.should_receive(:expand_path).with('~/tmp/cookbooks')
      @knife.config = { cookbook_path: '~/tmp/cookbooks' }
      @knife.stub(:create_cookbook_directories)
      @knife.stub(:create_cookbook_files)
      @knife.stub(:create_cookbook_templates)
      @knife.run
    end

    it 'should create a new cookbook' do
      @dir = Dir.tmpdir
      @knife.config = { cookbook_path: @dir }
      @knife.should_receive(:create_cookbook_directories).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_files).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_templates).with(
        @dir,
        @knife.name_args.first,
        'YOUR_COMPANY_NAME',
        'YOUR_EMAIL',
        'none',
        'md'
      )
      @knife.run
    end

    it 'should create a new cookbook with all parameters' do
      @dir = Dir.tmpdir
      @knife.config = {
        cookbook_path: @dir,
        cookbook_copyright: 'Got',
        cookbook_email: 'pierre.rambaud86@gmail.com',
        cookbook_license: 'lgplv3'
      }
      @knife.should_receive(:create_cookbook_directories).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_files).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_templates).with(
        @dir,
        @knife.name_args.first,
        'Got',
        'pierre.rambaud86@gmail.com',
        'lgplv3',
        'md'
      )
      @knife.run
    end

    it 'should set license to none if value is false (boolean)' do
      @dir = Dir.tmpdir
      @knife.config = {
        cookbook_path: @dir,
        cookbook_copyright: 'Got',
        cookbook_email: 'pierre.rambaud86@gmail.com',
        cookbook_license: false
      }
      @knife.should_receive(:create_cookbook_directories).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_files).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_templates).with(
        @dir,
        @knife.name_args.first,
        'Got',
        'pierre.rambaud86@gmail.com',
        'none',
        'md'
      )
      @knife.run
    end

    it 'should set license to none if value is false (string)' do
      @dir = Dir.tmpdir
      @knife.config = {
        cookbook_path: @dir,
        cookbook_copyright: 'Got',
        cookbook_email: 'pierre.rambaud86@gmail.com',
        cookbook_license: 'false'
      }
      @knife.should_receive(:create_cookbook_directories).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_files).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_templates).with(
        @dir,
        @knife.name_args.first,
        'Got',
        'pierre.rambaud86@gmail.com',
        'none',
        'md'
      )
      @knife.run
    end

    it 'should create cookbook directories with all files and templates' do
      @dir = Dir.tmpdir
      @knife.config = {
        cookbook_path: @dir,
        cookbook_copyright: 'Got',
        cookbook_email: 'pierre.rambaud86@gmail.com',
        cookbook_license: 'gplv3'
      }

      FakeFS::FileSystem.clone(
        File.expand_path(
          '.',
          Pathname.new(__FILE__).realpath
        )
      )
      @knife.ui.should_receive(:msg).with('Create cookbook foobar into /tmp')
      @knife.run
      %w(
        definitions
        libraries
        providers
        recipes
        resources
        spec
        files/default
        templates/default
        test/integration/default/serverspec).each do |dir_name|
        assert_file_exists(@dir, @knife.name_args.first, dir_name)
      end

      %w(
        Berksfile
        Gemfile
        .gitignore
        .rubocop.yml
        Strainerfile
        CHANGELOG.md
        .kitchen.yml
        metadata.rb
        README.md
        recipes/default.rb
        spec/default_spec.rb
        spec/spec_helper.rb
        test/integration/default/serverspec/spec_helper.rb
        test/integration/default/serverspec/default_spec.rb
      ).each do |file_name|
        assert_file_exists(@dir, @knife.name_args.first, file_name)
      end
    end

    def assert_file_exists(cookbook_path, cookbook_name, file_name)
      file_path = File.join(
        cookbook_path,
        cookbook_name,
        file_name
      )
      expect(File.exist?(file_path)).to be_truthy
    end
  end
end
