# -*- coding: utf-8 -*-
require 'erubis'

module KnifeSkeleton
  # Render template
  class Template
    # Static: Render template with Erubis
    #
    # template - Template string to used for rendering
    # data     - Data binding
    #
    # Examples:
    #
    #   create_cookbook_directories('Hello <%= title %>', {title: 'GoT'})
    #   # => "Hello GoT"
    #
    # Returns string
    def self.render(template, data)
      eruby = Erubis::Eruby.new(template)
      output = eruby.result(data)
      output
    end
  end
end
