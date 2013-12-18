module Stic

  # Represent a output blob containing data from a
  # source single file.
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
      read
    end

    # Return raw content.
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
