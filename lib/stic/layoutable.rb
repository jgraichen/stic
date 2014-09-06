module Stic

  # Provide functionality to wrap the rendered output
  # in a layout.
  #
  module Layoutable

    def render(opts = {})
      if layout && (opts[:layout].nil? || opts[:layout])
        layout.render(self) { render(layout: false) }
      else
        render_content self
      end
    end

    def layout
      @layout ||= layout_name.blank? ? nil : site.layout(layout_name)
    end

    def layout_name
      @layout_name ||= data['layout'] || default_layout
    end

    def default_layout
      'default'
    end
  end
end
