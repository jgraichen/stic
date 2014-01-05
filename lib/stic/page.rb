module Stic

  #
  #
  class Page < File
    attr_reader :site, :source, :content

    def initialize(*args)
      super
      load
    end

    def render
      templates = Tilt.templates_for name
      output    = self.content.to_s

      Tilt.templates_for(name).each do |engine|
        output = engine.new{ output }.render(self)
      end

      output
    end

    def url_template
      ::Stic::Utils.with_leading_slash path.gsub(/\.[^\/]+$/, '.html')
    end

    private
    def load
      content = self.read

      if (parser = ::Stic::Frontmatter.parse(self, content))
        @content = parser.content
        @data.merge! parser.data
      else
        @content = content
      end
    end

    class << self
      def valid?(file)
        File.file? file
      end
    end
  end
end
