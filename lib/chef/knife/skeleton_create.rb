# -*- coding: utf-8 -*-
require 'chef/knife'
require 'pathname'
require 'knife_skeleton/template'

module KnifeSkeleton
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
    # Returns void
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
    # Returns string
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

    protected

    # Protected: Create cookbook directories
    #
    # cookbook_path - Cookbook path
    # cookbook_name - Cookbook name
    #
    # Examples:
    #
    #   create_cookbook_directories('/tmp', 'my-cookbook')
    #
    # Returns void
    def create_cookbook_directories(cookbook_path, cookbook_name)
      ui.msg("Create cookbook #{cookbook_name} into #{cookbook_path}")

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

    # Protected: Create cookbook files from templates
    #
    # params - An Hash of parameters to use for binding template
    #
    # Examples:
    #
    #   create_cookbook_templates({ cookbook_path: '/tmp', title: 'GoT' })
    #
    # Returns void
    def create_cookbook_templates(params)
      template_directory = File.expand_path(
        '../../../../templates',
        Pathname.new(__FILE__).realpath
      )

      %W(
        CHANGELOG.#{params[:readme_format]}
        .kitchen.yml
        metadata.rb
        README.#{params[:readme_format]}
        recipes/default.rb
        spec/default_spec.rb
        spec/spec_helper.rb
        test/integration/default/serverspec/spec_helper.rb
        test/integration/default/serverspec/default_spec.rb
      ).each do |file_name|
        render_template(template_directory, file_name, params)
      end
    end

    # Protected: Copy all files into the cookbook
    #
    # cookbook_path - Cookbook path
    # cookbook_name - Cookbook name
    #
    # Examples:
    #
    #   create_cookbook_files('/tmp', 'my-cookbook')
    #
    # Returns void
    def create_cookbook_files(
      cookbook_path,
      cookbook_name
    )
      file_directory = File.expand_path(
        '../../../../files',
        Pathname.new(__FILE__).realpath
      )
      %w(
        Berksfile
        Gemfile
        .gitignore
        .rubocop.yml
        Strainerfile
      ).each do |file_name|
        copy_file(file_directory, cookbook_path, cookbook_name, file_name)
      end
    end

    # Protected: Copy files
    #
    # file_directory - The tested parameter
    # cookbook_path  - Cookbook path
    # cookbook_name  - Cookbook name
    # file_name      - File name to used without erb extension
    #
    # Examples:
    #
    #   copy_file('/tmp', '/cookbooks', 'my-cookbook', 'README.md')
    #
    # Returns void
    def copy_file(file_directory, cookbook_path, cookbook_name, file_name)
      dst = File.join(
        cookbook_path,
        cookbook_name,
        file_name
      )

      if File.exist?(dst)
        ui.warning("#{file_name} already exists")
      else
        ui.msg("Create '#{file_name}'")
        FileUtils.cp(
          File.join(
            file_directory,
            file_name.gsub(/^\./, '')
          ),
          dst
        )
      end
    end

    # Protected: Render template
    #
    # template_directory - The tested parameter
    # file_name          - File name to used without erb extension
    # params             - Binding parameters
    #
    # Examples:
    #
    #   render_template('/tmp', 'my-file.rb', { title: 'GoT' })
    #
    # Returns void
    def render_template(template_directory, file_name, params)
      dst = File.join(
        params[:cookbook_path],
        params[:cookbook_name],
        file_name
      )

      if File.exist?(dst)
        ui.warning("#{file_name} already exists")
      else
        ui.msg("Create '#{file_name}'")
        File.open(
          dst,
          'w+'
        ) do |file|
          file.write(
            Template.render(
              File.read(
                File.join(
                  template_directory,
                  file_name + '.erb'
                )
              ),
              params
            )
          )
        end
      end
    end

    # Protected: Test if parameter is empty
    #
    # parameter - The tested parameter
    #
    # Examples:
    #
    #   parameter_empty?('my string')
    #   # => false
    #   parameter_empty?('')
    #   # => true
    #
    # Returns string
    def parameter_empty?(parameter)
      parameter.nil? || parameter.empty?
    end

    # Protected: Get cookbook copyright
    #
    # Returns string
    def cookbook_copyright
      config[:cookbook_copyright] || 'YOUR_COMPANY_NAME'
    end

    # Protected: Get maintener email
    #
    # Returns string
    def cookbook_email
      config[:cookbook_email] || 'YOUR_EMAIL'
    end

    # Protected: Get license name
    #
    # Returns string
    def cookbook_license
      ((config[:cookbook_license] != 'false') &&
        config[:cookbook_license]) || 'none'
    end

    # Protected: Get readme format
    #
    # Returns string
    def cookbook_readme_format
      ((config[:readme_format] != 'false') && config[:readme_format]) || 'md'
    end
  end
end