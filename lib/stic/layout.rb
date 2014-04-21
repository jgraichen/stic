module Stic

  # = Stic::Layout
  #
  # A {Layout} allows to wrap a blob into a layout. The
  # rendered layout itself my be wrapped into another
  # layout.
  #
  class Layout
    include SiteBase
    include Readable
    include Renderable
    include Metadata

    def render(blob)
      locals = blob.locals.merge(data: data)

      if layout
        render_content(locals) { layout.render(blob) }
      else
        render_content(locals) { blob.render layout: false }
      end
    end

    def layout
      @layout ||= layout_name.blank? ? nil : site.layout(layout_name)
    end

    # Return name of layout this layout should be wrapped in.
    #
    def layout_name
      data[:layout]
    end

    def render_name
      @path.basename
    end

    class << self
      def load(site, source, config)
        layouts = {}

        source.join(config['layouts'] || 'layouts').glob('*').each do |path|
          next unless path.file?

          layouts[path.pure_name] = new site: site, source: path
        end

        layouts
      end
    end
  end
end
