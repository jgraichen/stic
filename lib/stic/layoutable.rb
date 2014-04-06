module Stic

  # Provide functionality to wrap the rendered output
  # in a layout.
  #
  module Layoutable
    extend ::ActiveSupport::Concern

    included do
      # Define a class wide layout that will be used
      # for all instances if no other layout is specified.
      # Defaults to `default` if not set.
      cattr_accessor :layout
      self.layout = 'default'
    end

    def render
      # TODO: Wrap in layout
      super
    end

    def layout
      @layout ||= site.layouts.find{|l| l.name == layout_name }
    end

    def layout_name
      @layout_name ||= data['layout'] || self.class.layout
    end
  end
end
