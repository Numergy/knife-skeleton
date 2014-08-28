# -*- coding: utf-8 -*-
require 'spec_helper'
require 'chef/knife/skeleton_create'
require 'fakefs/spec_helpers'

describe Knife::SkeletonCreate do
  include FakeFS::SpecHelpers

  before(:each) do
    @knife = Knife::SkeletonCreate.new
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
      params = {
        cookbook_path: @dir,
        cookbook_name: @knife.name_args.first,
        copyright: 'YOUR_COMPANY_NAME',
        email: 'YOUR_EMAIL',
        license: 'none',
        license_name: 'All rights reserved',
        readme_format: 'md'
      }
      @knife.should_receive(:create_cookbook_templates).with(params)
      @knife.run
    end

    it 'should create a new cookbook with all parameters' do
      @dir = Dir.tmpdir
      @knife.config = {
        cookbook_path: @dir,
        cookbook_copyright: 'Got',
        cookbook_email: 'pierre.rambaud86@gmail.com',
        cookbook_license: 'gplv3'
      }
      @knife.should_receive(:create_cookbook_directories).with(
        @dir,
        @knife.name_args.first
      )
      @knife.should_receive(:create_cookbook_files).with(
        @dir,
        @knife.name_args.first
      )
      params = {
        cookbook_path: @dir,
        cookbook_name: @knife.name_args.first,
        copyright: 'Got',
        email: 'pierre.rambaud86@gmail.com',
        license: 'gplv3',
        license_name: 'GNU Public License 3.0',
        readme_format: 'md'
      }
      @knife.should_receive(:create_cookbook_templates).with(params)
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
      params = {
        cookbook_path: @dir,
        cookbook_name: @knife.name_args.first,
        copyright: 'Got',
        email: 'pierre.rambaud86@gmail.com',
        license: 'none',
        license_name: 'All rights reserved',
        readme_format: 'md'
      }
      @knife.should_receive(:create_cookbook_templates).with(params)
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
      params = {
        cookbook_path: @dir,
        cookbook_name: @knife.name_args.first,
        copyright: 'Got',
        email: 'pierre.rambaud86@gmail.com',
        license: 'none',
        license_name: 'All rights reserved',
        readme_format: 'md'
      }
      @knife.should_receive(:create_cookbook_templates).with(params)
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
          '../../../../',
          Pathname.new(__FILE__).realpath
        )
      )

      @knife.ui.should_receive(:msg).with('** Create cookbook foobar into /tmp')
      @knife.ui.should_receive(:msg).with("** Create 'Berksfile'")
      @knife.ui.should_receive(:msg).with("** Create 'Gemfile'")
      @knife.ui.should_receive(:msg).with("** Create '.gitignore'")
      @knife.ui.should_receive(:msg).with("** Create '.travis.yml'")
      @knife.ui.should_receive(:msg).with("** Create '.rubocop.yml'")
      @knife.ui.should_receive(:msg).with("** Create '.kitchen.yml'")
      @knife.ui.should_receive(:msg).with("** Create 'Strainerfile'")
      @knife.ui.should_receive(:msg).with("** Create 'CHANGELOG.md'")
      @knife.ui.should_receive(:msg).with("** Create 'metadata.rb'")
      @knife.ui.should_receive(:msg).with("** Create 'README.md'")
      @knife.ui.should_receive(:msg).with("** Create 'attributes/default.rb'")
      @knife.ui.should_receive(:msg).with("** Create 'recipes/default.rb'")
      @knife.ui.should_receive(:msg).with("** Create 'spec/default_spec.rb'")
      @knife.ui.should_receive(:msg).with("** Create 'spec/spec_helper.rb'")
      @knife.ui.should_receive(:msg).with(
        "** Create 'test/integration/default/serverspec/spec_helper.rb'")
      @knife.ui.should_receive(:msg).with(
        "** Create 'test/integration/default/serverspec/default_spec.rb'")
      @knife.run
      # Run txice to tests warn
      @knife.ui.should_receive(:msg).with('** Create cookbook foobar into /tmp')
      @knife.ui.should_receive(:warn).with("'Berksfile' already exists")
      @knife.ui.should_receive(:warn).with("'Gemfile' already exists")
      @knife.ui.should_receive(:warn).with("'.gitignore' already exists")
      @knife.ui.should_receive(:warn).with("'.rubocop.yml' already exists")
      @knife.ui.should_receive(:warn).with("'.kitchen.yml' already exists")
      @knife.ui.should_receive(:warn).with("'.travis.yml' already exists")
      @knife.ui.should_receive(:warn).with("'Strainerfile' already exists")
      @knife.ui.should_receive(:warn).with("'metadata.rb' already exists")
      @knife.ui.should_receive(:warn).with("'CHANGELOG.md' already exists")
      @knife.ui.should_receive(:warn).with("'README.md' already exists")
      @knife.ui.should_receive(:warn).with(
        "'attributes/default.rb' already exists")
      @knife.ui.should_receive(:warn).with(
        "'recipes/default.rb' already exists")
      @knife.ui.should_receive(:warn).with(
        "'spec/default_spec.rb' already exists")
      @knife.ui.should_receive(:warn).with(
        "'spec/spec_helper.rb' already exists")
      @knife.ui.should_receive(:warn).with(
        "'test/integration/default/serverspec/spec_helper.rb' already exists")
      @knife.ui.should_receive(:warn).with(
        "'test/integration/default/serverspec/default_spec.rb' already exists")
      @knife.run

      %w(
        attributes
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
        metadata.rb
        Berksfile
        Gemfile
        .gitignore
        .rubocop.yml
        .travis.yml
        .kitchen.yml
        Strainerfile
        CHANGELOG.md
        README.md
        attributes/default.rb
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

  describe 'cookbook_license_name' do
    it 'should test with apache2 license' do
      @knife.config = { cookbook_license: 'apachev2' }
      expect(@knife.cookbook_license_name).to eq('Apache 2.0')
    end

    it 'should test with gplv2 license' do
      @knife.config = { cookbook_license: 'gplv2' }
      expect(@knife.cookbook_license_name).to eq('GNU Public License 2.0')
    end

    it 'should test with gplv3 license' do
      @knife.config = { cookbook_license: 'gplv3' }
      expect(@knife.cookbook_license_name).to eq('GNU Public License 3.0')
    end

    it 'should test with mit license' do
      @knife.config = { cookbook_license: 'mit' }
      expect(@knife.cookbook_license_name).to eq('MIT')
    end

    it 'should test with none license' do
      @knife.config = { cookbook_license: 'none' }
      expect(@knife.cookbook_license_name).to eq('All rights reserved')
    end
  end
end
