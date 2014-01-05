module Stic::Generators

  # The page generators adds page blobs for each page from
  # define directory. Pages are printable content that
  # may have a front matter and can be converted to HTML.
  #
  # The source path for pages will be taken from
  # generator config key `path` and defaults to `./pages`.
  #
  # You can override the path in your site configuration:
  #
  #     generators:
  #       pages:
  #         path: ./custom_pages
  #
  class Page < ::Stic::Generators::Static

    def path_default
      'pages'
    end

    def blob_class
      ::Stic::Page
    end
  end

  ::Stic::Site.generators << Page
end
