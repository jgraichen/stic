module Stic

  # Represents a file in generated site.
  #
  class File
    attr_reader :site, :base, :name

    def initialize(site, base, name)
      @site = site
      @base = base
      @name = name
    end

    # Return source relative path.
    #
    def path
      "#{base}/#{name}"
    end

    # Return full source path.
    #
    def source_path
      site.source.join "./#{path}"
    end

    # Return full target path.
    #
    def target_path
      site.target.join url[-1] == '/' ? "./#{url}/index.html" : "./#{url}"
    end

    # Return site relative URL.
    #
    def url
      ::Stic::Utils.ensure_leading_slash path
    end

    # Write to target file.
    #
    def write
      ::FileUtils.mkdir_p ::File.dirname target_path
      ::File.write target_path, render
    end

    # Return final output as string.
    #
    def render
      read
    end

    # Return raw content.
    #
    def read
      ::File.read source_path
    end
    alias_method :to_s, :read

    def inspect
      "#<#{self.class.name}:#{object_id} #{path}>"
    end

    class << self
      def valid?(path)
        ::File.file? path
      end
    end
  end
end
