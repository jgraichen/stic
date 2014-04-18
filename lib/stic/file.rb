module Stic

  # Represent an output blob containing data from a
  # single source file.
  #
  # Subclasses can override the `render` method to
  # implement processing logic.
  #
  class File < Blob

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
    # @option opts [#to_s] :source *Required* Base path. See {#base}.
    # @option opts [#to_s] :path *Required* Blob path. See {#path}.
    # @option opts [String] :name Optional blob file name. See {#name}.
    #
    def initialize(opts = {})
      super

      source = opts.delete(:source) { raise ::ArgumentError.new 'Argument `:source` required.' }
      path   = opts.delete(:path)   { raise ::ArgumentError.new 'Argument `:path` required.' }

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
