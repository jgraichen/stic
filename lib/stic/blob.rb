module Stic
  #
  # = Stic::Blob
  # A {Blob} represents a single output file. It does not
  # assume any specific source or processing.
  #
  # Blob provides the basic functionality {Site} expects
  # for managing and writing blobs. Blob should not be used
  # directly but sub-classed to provide an actual
  # implementation of at least {#url_template} and {#render}.
  #
  # See {File} for a simple blob implementation serving a
  # static file or {Page} for a more future rich example
  # including rendering.
  #
  class Blob
    include SiteBase

    # @!group Accessors

    # Return a the relative URL the blob should have in generated site. The URL
    # is based on the URL template where placeholders are replaced with values
    # from {#data}.
    #
    # Example: Given the URL template `/blog/:year/:slug.html` and a blob data
    # hash of `{:year => 2014, :slug => 'a-blog-post'}` the resulting relative
    # URL would be '/blog/2014/a-blog-post.html'. Only `A-z0-9_` are allowed as
    # a placeholder.
    #
    # @return [Path] URL relative to site root but as an absolute path.
    #
    def relative_url
      parts = url_template.each_component(empty: true).map do |fn|
        fn =~ /^:([A-z0-9_]+)$/ ? data[$1] : fn
      end
      Path '/', parts
    end

    # Return the site relative target path.
    #
    # The relative target path must be based on the URL.
    #
    # The default implementation joins the relative URL with `index.html` if
    # the relative URL does not have any file extension. Otherwise the
    # relative URL will be returned.
    #
    # @return [Path] Target file path relative to site target path.
    #
    def relative_target_path
      if relative_url.extensions.empty?
        relative_url.join('index.html')
      else
        relative_url
      end
    end

    # Return full target path.
    #
    # The target path is based on the site target dir and the relative target
    # path. You should not override this method. Instead provide a custom
    # relative target path or URL.
    #
    # @return [Pathname] Fill blob file path.
    #
    def target_path
      site.target.join relative_target_path.as_relative
    end

    # @!group Actions

    # Write rendered blob to file.
    #
    # Path from {#target_path} will be used as the file path.
    #
    # You should not override this method. Instead provide a custom {#render}
    # method to customize written result.
    #
    def write
      unless ::File.directory?((dir = ::File.dirname(target_path)))
        FileUtils.mkdir_p dir
      end

      ::File.open target_path, 'w' do |file|
        file.write render
      end
    end
  end
end
