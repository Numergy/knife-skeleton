# -*- coding: utf-8 -*-
require 'erubis'

module KnifeSkeleton
  # Render template
  class Template
    def self.render(template, data)
      eruby = Erubis::Eruby.new(template)
      output = eruby.result(data)
      output
    end
  end
end
