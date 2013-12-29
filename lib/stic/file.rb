module Stic

  # Represent an output blob containing data from a
  # single source file.
  #
  # Subclasses can override the `render` method to
  # implement processing logic.
  #
  class File < Blob
    attr_reader :base, :name

    def initialize(args = {})
      super
      if (file = args[:file])
        args[:base] ||= ::File.dirname file
        args[:name] ||= ::File.basename file
      end

      @base = args.delete(:base) { raise ::ArgumentError.new 'Argument `:base` required.' }
      @name = args.delete(:name) { raise ::ArgumentError.new 'Argument `:name` required.' }
    end

    # Return source relative path.
    #
    def relative_source_path
      "#{base}/#{name}"
    end

    # Return full source path.
    #
    def source_path
      site.source.join ::Stic::Utils.without_leading_slash relative_source_path
    end

    # Return site relative URL.
    #
    def url_template
      ::Stic::Utils.with_leading_slash relative_source_path
    end

    # Return final output as string.
    #
    def render
      content
    end

    # Return file content.
    #
    # This method caches file content and should be
    # favored over `read`.
    #
    def content
      @content ||= read
    end

    # Read and return raw content.
    #
    # It directly read the content from file every time
    # called and should be avoided in favor of `content`.
    #
    # It can be overridden by subclasses implementing
    # special input reading behavior.
    #
    def read
      ::File.read source_path
    end

    class << self
      def valid?(path)
        ::File.file? path
      end
    end
  end
end
