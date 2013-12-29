module Stic

  #
  #
  class Page < File
    attr_reader :site, :source

    def initialize(site, source)
      @site   = site
      @source = source
    end

    def render

    end

    def data
      @data ||= begin
        if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          @content = $POSTMATCH
          YAML.safe_load($1)
        else
          {}
        end
      end
    end

    class << self
      def valid?(file)
        File.file? file
      end
    end
  end
end
