# -*- coding: utf-8 -*-
require 'chef/knife'
require 'pathname'

module KnifeSkeleton
  # Cookbook class
  class Cookbook < Chef::Knife
    banner 'knife skeleton create COOKOOK (options)'

    option :cookbook_path,
           short: '-o PATH',
           long: '--cookbook-path PATH',
           description: 'The directory where the cookbook will be created'

    option :cookbook_license,
           short: '-I LICENSE',
           long: '--license LICENSE',
           description: 'License apachev2, gplv2, gplv3, mit or none'

    option :cookbook_copyright,
           short: '-C COPYRIGHT',
           long: '--copyright COPYRIGHT',
           description: 'Name of Copyright holder'

    option :cookbook_email,
           short: '-m EMAIL',
           long: '--email EMAIL',
           description: 'Email address of cookbook maintainer'

    def run
      self.config = Chef::Config.merge!(config)
      if @name_args.length < 1
        show_usage
        ui.fatal('You must specify a cookbook name')
      end

      if default_cookbook_path_empty? && parameter_empty(config[:cookbook_path])
        fail ArgumentError, <<-eos
                             Default cookbook_path is not specified in the
                             knife.rb config file, and a value to -o is
                             not provided. Nowhere to write the new cookbook to.
                             eos
      end

      cookbook_path = File.expand_path(Array(config[:cookbook_path]).first)
      cookbook_name = @name_args.first
      # copyright = config[:cookbook_copyright] || 'YOUR_COMPANY_NAME'
      # email = config[:cookbook_email] || 'YOUR_EMAIL'
      # license = (
      #            (config[:cookbook_license] != 'false') &&
      #            config[:cookbook_license]) || 'none'

      create_cookbook(cookbook_path, cookbook_name)
    end

    def create_cookbook(cookbook_path, cookbook_name)
      msg("Create cookbook #{cookbook_name} into #{cookbook_path}")
      %w(
        definitions
        libraries
        providers
        recipes
        resources
        spec
        files/default
        templates/default
        test/integration/default/serverspec).each do |dir|
        FileUtils.mkdir_p(
          File.join(
            cookbook_path,
            cookbook_name,
            dir
          )
        )
      end
    end
  end
end
