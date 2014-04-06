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

    def path_default
      'files'
    end

    def path
      @path ||= config[:path] || path_default
    end

    def full_path
      @full_path ||= site.source.join(path)
    end

    def blob_class
      ::Stic::File
    end

    def run
      Dir[full_path.join('**/*')].each do |file|
        if ::File.file? file
          file = file[full_path.to_s.length .. -1]
          site << blob_class.new(site: site, base: path, path: file)
        end
      end
    end
  end

  ::Stic::Site.generators << Static
end
