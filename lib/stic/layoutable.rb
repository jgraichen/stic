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
      # class_attribute :layout
      self.layout = 'default'
    end

    def render(opts = {})
      if layout
        layout.render parent: self
      else
        super
      end
    end

    def layout
      @layout ||= layout_name.blank? ? nil : site.layout(layout_name)
    end

    def layout_name
      @layout_name ||= data['layout'] || self.class.layout
    end

    #
    module ClassMethods
      attr_writer :layout

      def layout
        @layout ||= 'default'
      end
    end
  end
end
