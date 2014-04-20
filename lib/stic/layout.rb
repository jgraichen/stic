module Stic

  # = Stic::Layout
  #
  # A {Layout} allows to wrap a rendered content into
  # something else that may consist of templated yielding
  # the given content.
  #
  class Layout < Blob
    include Readable
    include Renderable
    include Metadata
    include Layoutable

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
