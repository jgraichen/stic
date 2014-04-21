module Stic

  # Represent an output blob containing data from a
  # single source file.
  #
  # Subclasses can override the `render` method to
  # implement processing logic.
  #
  class File < Blob
    include Readable

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
  end
end
