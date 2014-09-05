module Stic

  class Renderer
    attr_reader :blob, :path, :name

    def initialize(blob)
      @blob = blob
      @path = blob.source_path
    end

    def render(locals, &block)
      engines = Tilt.templates_for(path.basename)
      engines.reduce(blob.content) do |content, engine|
        engine.new(path){ content.to_s }.render(Environment, locals, &block)
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
      class << self
        def uri_escape(str)
          ::URI.escape str.to_s
        end
      end
    end
  end
end
