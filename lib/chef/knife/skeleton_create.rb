# -*- coding: utf-8 -*-
require 'chef/knife'
require 'pathname'
require 'knife_skeleton/template'

module Knife
  # Cookbook class
  class SkeletonCreate < Chef::Knife
    banner 'knife skeleton create COOKOOK (options)'

    option :cookbook_path,
           short: '-o PATH',
           long: '--cookbook-path PATH',
           description: <<-eos
The directory where the cookbook will be created
eos

    option :readme_format,
           short: '-r FORMAT',
           long: '--readme-format FORMAT',
           description: <<-eos
Format of the README file, supported formats are 'md', 'rdoc' and 'txt'
eos

    option :cookbook_license,
           short: '-I LICENSE',
           long: '--license LICENSE',
           description: <<-eos
License apachev2, gplv2, gplv3, mit or none
eos

    option :cookbook_copyright,
           short: '-C COPYRIGHT',
           long: '--copyright COPYRIGHT',
           description: <<-eos
Name of Copyright holder
eos

    option :cookbook_email,
           short: '-m EMAIL',
           long: '--email EMAIL',
           description: <<-eos
Email address of cookbook maintainer
eos

    # Public: Knife skeleton create runner
    #
    # @return [Void]
    #
    def run
      self.config = Chef::Config.merge!(config)
      if @name_args.length < 1
        show_usage
        ui.fatal('You must specify a cookbook name')
        exit 1
      end

      if parameter_empty?(config[:cookbook_path])
        fail ArgumentError, <<-eos
                             Default cookbook_path is not specified in the
                             knife.rb config file, and a value to -o is
                             not provided. Nowhere to write the new cookbook to.
                             eos
      end

      params = {
        cookbook_path: File.expand_path(Array(config[:cookbook_path]).first),
        cookbook_name: @name_args.first,
        copyright: cookbook_copyright,
        email: cookbook_email,
        license: cookbook_license,
        license_name: cookbook_license_name,
        readme_format: cookbook_readme_format
      }

      create_cookbook_directories(
        params[:cookbook_path],
        params[:cookbook_name]
      )
      create_cookbook_files(params[:cookbook_path], params[:cookbook_name])
      create_cookbook_templates(params)
    end

    # Public: Retrieve license name
    #
    # Examples:
    #
    #   # With mit license
    #   cookbook_license_name
    #   # => 'MIT'
    #   # With apachev2 license
    #   cookbook_license_name
    #   # => 'Apache 2.0'
    #   # With gplv3 license
    #   cookbook_license_name
    #   # => 'GNU Public LIcense 3.0'
    #
    # @return [String]
    #
    def cookbook_license_name
      case cookbook_license
      when 'apachev2'
        'Apache 2.0'
      when 'gplv2'
        'GNU Public License 2.0'
      when 'gplv3'
        'GNU Public License 3.0'
      when 'mit'
        'MIT'
      when 'none'
        'All rights reserved'
      end
    end

    # Create cookbook directories
    #
    # Examples:
    #
    #   create_cookbook_directories('/tmp', 'my-cookbook')
    #
    # @param [String] cookbook_path Cookbook path
    # @param [String] cookbook_name Cookbook name
    # @return [Void]
    #
    def create_cookbook_directories(cookbook_path, cookbook_name)
      ui.msg("** Create cookbook #{cookbook_name} into #{cookbook_path}")

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

    # Create cookbook files from templates
    #
    # Examples:
    #
    #   create_cookbook_templates({ cookbook_path: '/tmp', title: 'GoT' })
    #
    # @params [Hash] params An Hash of parameters to use for binding template
    # @return [Void]
    #
    def create_cookbook_templates(params)
      params[:license_content] = File.read(
        File.join(
          files_directory,
          'licenses',
          params[:license]
        )
      ) if params[:license] != 'none'

      params[:license_content] = '' unless params[:license] != 'none'

      %W(
        metadata.rb
        CHANGELOG.#{params[:readme_format]}
        README.#{params[:readme_format]}
        .kitchen.yml
        attributes/default.rb
        recipes/default.rb
        spec/default_spec.rb
        spec/spec_helper.rb
        test/integration/default/serverspec/spec_helper.rb
        test/integration/default/serverspec/default_spec.rb
      ).each do |file_name|
        render_template(file_name, params)
      end
    end

    # Copy all files into the cookbook
    #
    # Examples:
    #
    #   create_cookbook_files('/tmp', 'my-cookbook')
    #
    # @param [String] cookbook_path Cookbook path
    # @param [String] cookbook_name Cookbook name
    # @return [Void]
    #
    def create_cookbook_files(
      cookbook_path,
      cookbook_name
    )
      %w(
        Berksfile
        Gemfile
        .gitignore
        .rubocop.yml
        .travis.yml
        Strainerfile
      ).each do |file_name|
        copy_file(cookbook_path, cookbook_name, file_name)
      end
    end

    # Copy files
    #
    # Examples:
    #
    #   copy_file('/tmp', '/cookbooks', 'my-cookbook', 'README.md')
    #
    # @param [String] cookbook_path Cookbook path
    # @param [String] cookbook_name Cookbook name
    # @param [String] file_name    File name to used without erb extension
    # @return [Void]
    #
    def copy_file(cookbook_path, cookbook_name, file_name)
      dst = File.join(
        cookbook_path,
        cookbook_name,
        file_name
      )

      if File.exist?(dst)
        ui.warn("'#{file_name}' already exists")
      else
        ui.msg("** Create '#{file_name}'")
        FileUtils.cp(
          File.join(
            files_directory,
            file_name.gsub(/^\./, '')
          ),
          dst
        )
      end
    end

    # Render template
    #
    # Examples:
    #
    #   render_template('/tmp', 'my-file.rb', { title: 'GoT' })
    #
    # @param [String] file_name File name to used without erb extension
    # @param [Hash]   params    Binding parameters
    # @return [void]
    #
    def render_template(file_name, params)
      dst = File.join(
        params[:cookbook_path],
        params[:cookbook_name],
        file_name
      )

      if File.exist?(dst)
        ui.warn("'#{file_name}' already exists")
      else
        ui.msg("** Create '#{file_name}'")
        File.open(
          dst,
          'w+'
        ) do |file|
          file.write(
            KnifeSkeleton::Template.render(
              File.read(
                File.join(
                  templates_directory,
                  file_name + '.erb'
                )
              ),
              params
            )
          )
        end
      end
    end

    # Test if parameter is empty
    #
    # Examples:
    #
    #   parameter_empty?('my string')
    #   # => false
    #   parameter_empty?('')
    #   # => true
    #
    # @param [Mixed] parameter The tested parameter
    # @return [String]
    #
    def parameter_empty?(parameter)
      parameter.nil? || parameter.empty?
    end

    # Get cookbook copyright
    #
    # @return [String]
    #
    def cookbook_copyright
      config[:cookbook_copyright] || 'YOUR_COMPANY_NAME'
    end

    # Get maintener email
    #
    # @return [String]
    #
    def cookbook_email
      config[:cookbook_email] || 'YOUR_EMAIL'
    end

    # Get license name
    #
    # @return [String]
    #
    def cookbook_license
      ((config[:cookbook_license] != 'false') &&
        config[:cookbook_license]) || 'none'
    end

    # Get readme format
    #
    # @return [String]
    #
    def cookbook_readme_format
      ((config[:readme_format] != 'false') && config[:readme_format]) || 'md'
    end

    # Get files directory
    #
    # @return [String]
    #
    def files_directory
      File.expand_path(
        '../../../../files',
        Pathname.new(__FILE__).realpath
      )
    end

    # Get templates directory
    #
    # @return [String]
    #
    def templates_directory
      File.expand_path(
        '../../../../templates',
        Pathname.new(__FILE__).realpath
      )
    end
  end
end
