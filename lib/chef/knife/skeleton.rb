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
Format of the README file, supported formats are 'md' and'rdoc'
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
        FileUtils.cp(
          File.join(
            file_directory,
            file_name.gsub(/^\./, '')
          ),
          File.join(
            cookbook_path,
            cookbook_name,
            file_name
          )
        )
      end
    end

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

    def render_template(template_directory, file_name, params)
      File.open(
        File.join(
          params[:cookbook_path],
          params[:cookbook_name],
          file_name
        ),
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

    def parameter_empty?(parameter)
      parameter.nil? || parameter.empty?
    end

    def cookbook_copyright
      config[:cookbook_copyright] || 'YOUR_COMPANY_NAME'
    end

    def cookbook_email
      config[:cookbook_email] || 'YOUR_EMAIL'
    end

    def cookbook_license
      ((config[:cookbook_license] != 'false') &&
        config[:cookbook_license]) || 'none'
    end

    def cookbook_readme_format
      ((config[:readme_format] != 'false') && config[:readme_format]) || 'md'
    end
  end
end
