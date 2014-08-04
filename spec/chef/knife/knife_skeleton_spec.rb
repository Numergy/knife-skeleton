require 'spec_helper'
require 'chef/knife/skeleton'

describe KnifeSkeleton::Cookbook do
  before(:each) do
    @knife = KnifeSkeleton::Cookbook.new
    @knife.config = {}
    @knife.name_args = ['foobar']
    @stdout = StringIO.new
    @knife.stub(:stdout).and_return(@stdout)
  end

  describe "run" do
    it 'should show usage if there is no cookbook name' do
      @knife.config = {}
      @knife.name_args = []
      @knife.ui.should_receive(:fatal).with('You must specify a cookbook name')
      lambda { @knife.run }.should raise_error SystemExit
    end

    it 'should raise ArgumentError if there is no cookbook path' do
      @knife.config = {cookbook_path: ''}
      lambda { @knife.run }.should raise_error ArgumentError
    end

    it 'should expand the path of the cookbook directory' do
      File.should_receive(:expand_path).with('~/tmp/cookbooks')
      @knife.config = {cookbook_path: '~/tmp/cookbooks'}
      @knife.stub(:create_cookbook_directories)
      @knife.stub(:create_cookbook_templates)
      @knife.run
    end

    it 'should create new cookbook' do
      @dir = Dir.tmpdir
      @knife.config = {cookbook_path: @dir}
      @knife.should_receive(:create_cookbook_directories).with(@dir, @knife.name_args.first)
      @knife.should_receive(:create_cookbook_templates).with(
        @dir,
        @knife.name_args.first,
        'YOUR_COMPANY_NAME',
        'YOUR_EMAIL',
        'none'
      )
      @knife.run
    end
  end
end
