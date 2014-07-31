require_relative 'spec_helper'

module KnifeSkeleton
  describe "Template.render" do
    it "renders ERB template" do
      template = "May the force be with <%= name %>."
      data = { name: 'you' }
      output = Template.render(template, data)
      output.should == 'May the force be with you.'
    end
  end
end
