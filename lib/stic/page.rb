module Stic

  #
  #
  class Page < File
    attr_reader :site, :source, :content, :data

    def initialize(site, source)
      @site   = site
      @source = source
      @data   = {}

      read
    end

    def read
      begin
        @content = File.read(source)

        if @content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          @content = $POSTMATCH
          @data    = YAML.safe_load($1)
        end
      rescue SyntaxError => e
        puts "YAML Exception reading #{source}: #{e.message}"
      rescue Exception => e
        puts "Error reading file #{source}: #{e.message}"
      end
    end

    def render

    end

    class << self
      def valid?(file)
        File.file? file
      end
    end
  end
end
