module Stic::Generators

  # The static generators adds file blobs for each static
  # file to the generated output.
  #
  # The source path for static files will be taken from
  # generator config key `path` and defaults to `./files`.
  #
  # You can override the path in your site configuration:
  #
  #     generators:
  #       static:
  #         path: ./custom_files
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
