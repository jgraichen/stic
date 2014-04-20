module Stic
  #
  # = Stic::Readable
  #
  # Include this module for blobs that have a source file.
  # It provides methods for reading and storing the source
  # file.
  #
  module Readable
    # @!group Attributes

    # The full path to source file.
    #
    # @return [Path] Base path.
    #
    attr_reader :source

    # The virtual path to this file including file name. This path
    # represents the target in the generated output.
    #
    # The path will be used to derive the {#url_template}.
    #
    # @return [Path] File blob path.
    #
    attr_reader :path

    # The blob file name. Will be used as file name in {#url_template} and
    # therefor in {#relative_target_path} etc. The {#name} will be taken from
    # {#path}'s file name if not specified in the constructor.
    #
    # @return [String] File blob name.
    #
    attr_reader :name

    # @!group Construction

    # Initialize new file blob object.
    #
    # @param opts [Hash] Initialization options.
    # @option opts [#to_s] :source *Required* Full source path. See {#source}.
    # @option opts [#to_s] :path   Output path.
    #   Will use source path if not given. See {#path}.
    # @option opts [String] :name  Optional blob file name. See {#name}.
    #
    def initialize(opts = {})
      super

      source = opts.delete(:source) { raise ::ArgumentError.new 'Argument `:source` required.' }
      path   = opts.delete(:path)   { source }

      @source = Path(source).expand
      @path   = Path(path).as_relative
      @name   = opts.delete(:name) || @path.name
    end

    # @!group Accessors

    # Return full source path.
    #
    # @return [Path] (Absolute) source path.
    #
    def source_path
      source
    end

    # Return site relative URL.
    #
    # File blobs do not have a variable URL template by default so the
    # {#url_template} is equal the {#relative_url} and consists of the blob
    # {#path} and the blob file {#name}.
    #
    # As subclasses can override {#url_template} with custom behavior the file
    # blob class does not override the placeholder replacement login in
    # {#relative_url} but {#url_template} that returns a URL without
    # placeholders.
    #
    # @return [Path] Relative blob URL.
    #
    # @see Blob#url_template
    #
    def url_template
      path.dirname.join(name).as_absolute
    end

    # Return final output as string.
    #
    # On file blob this will just returned the unchanged {#content}.
    #
    # @return [String] Blob output.
    #
    def render
      content
    end

    # Return file content.
    #
    # This method caches file content and should be
    # favored over {#read}.
    #
    # @return [String] Blob content.
    #
    def content
      @content ||= read
    end

    # @!group Actions

    # Read and return raw content.
    #
    # It directly read the content from file every time
    # called and should be avoided in favor of {#content}.
    #
    # It can be overridden by subclasses implementing
    # special input reading behavior.
    #
    # @return [String] Red content.
    #
    def read
      source_path.read
    end
  end
end
