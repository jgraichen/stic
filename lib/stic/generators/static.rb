module Stic::Generators

  #
  class StaticGenerator < ::Stic::Generator

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

  ::Stic::Site.generators << StaticGenerator
end
