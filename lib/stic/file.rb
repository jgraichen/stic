module Stic

  # Represent an output blob containing data from a
  # single source file.
  #
  # Subclasses can override the `render` method to
  # implement processing logic.
  #
  class File < Blob

    # @!group Attributes

    # The base path used to determine the source path. The base path will be
    # joined with the {Site} source and the file path like this:
    # `<site.source>/<base>/<path>`.
    #
    # For example the {::Stic::Generators::Static} loads files from
    # `<site.source>/files` by default but added blobs should not contain
    # `/files` in their URLs, so the generator adds file blobs with the base
    # `files`, and the rest as the {#path}. This way the source path will
    # include `/files` but the URL derived from {#path} will not.
    #
    # @return [Path] Base path.
    #
    attr_reader :base

    # The file blob path contains the file path relative to {#base} and
    # {Site#source}. That includes the file name.
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
    # @option opts [#to_s] :base *Required* Base path. See {#base}.
    # @option opts [#to_s] :path *Required* Blob path. See {#path}.
    # @option opts [String] :name Optional blob file name. See {#name}.
    #
    def initialize(opts = {})
      super

      base = opts.delete(:base) { raise ::ArgumentError.new 'Argument `:base` required.' }
      path = opts.delete(:path) { raise ::ArgumentError.new 'Argument `:path` required.' }

      @base = ::Path.new(base).as_relative
      @path = ::Path.new(path).as_relative
      @name = opts.delete(:name) || @path.name
    end

    # @!group Accessors

    # Return blob source path relative to {Site#source}.
    #
    # The relative source path is the {#base} path joined
    # with the blob {#path}.
    #
    # @return [Path] Relative source path.
    #
    def relative_source_path
      base.join path
    end

    # Return full source path.
    #
    # The is the (absolute) source path including {Site#source}.
    #
    # @return [Path] (Absolute) source path.
    #
    def source_path
      site.source.join relative_source_path.as_relative
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
