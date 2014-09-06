module Stic

  class Renderer
    attr_reader :blob, :path, :name

    def initialize(blob)
      @blob = blob
      @path = blob.source_path
    end

    def render(context, &block)
      environment = Environment.new(context)
      engines     = Tilt.templates_for(path.basename)
      engines.reduce(blob.content) do |content, engine|
        engine.new(path){ content.to_s }.render(environment, context.locals, &block)
      end.html_safe
    end

    # A module to include additional rendering helper functions.
    #
    # @example
    #   module MyHelpers
    #     def help
    #       "Help here!"
    #     end
    #   end
    #   Stic::Renderer::Environment.extend MyHelpers
    #
    module Environment
      def uri_escape(str)
        ::URI.escape str.to_s
      end

      def url(blob)
        case blob
          when Stic::Blob
            blob.relative_url.relative_from(self.blob.relative_url.dirname)
          else
            Path(blob.to_s).relative_from(self.blob.relative_url.dirname)
        end
      end

      class << self
        def new(blob)
          cls = Class.new
          cls.send :include, Environment
          cls.send(:define_method, :blob) { blob }
          cls.new
        end
      end
    end
  end
end
