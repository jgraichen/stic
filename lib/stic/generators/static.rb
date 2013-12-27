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
  class Static < ::Stic::Generator

    def path
      config[:path] || 'files'
    end

    def run
      Dir[site.source.join(path).join("**/*")].each do |file|
        if ::File.file? file
          file = file[site.source.to_s.length .. -1]
          site << ::Stic::File.new(site: site, file: file)
        end
      end
    end
  end

  ::Stic::Site.generators << Static
end
