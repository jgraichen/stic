module Stic

  # Provide functionality to wrap the rendered output
  # in a layout.
  #
  module Layoutable
    extend ::ActiveSupport::Concern

    def render(opts = {})
      if layout && (opts[:layout].nil? || opts[:layout])
        layout.render(self) { render(layout: false) }
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
