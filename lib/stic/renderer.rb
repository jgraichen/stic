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
        engine.new(path){ content.to_s }.render(environment, locals, &block)
      end.html_safe
    end

    def environment
      self.class.environment
    end

    class << self
      def environment
        @environment ||= Module.new
      end
    end
  end
end
