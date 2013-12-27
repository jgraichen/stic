module Stic

  # A Blob represents a single output file. It does not
  # assume any specific source or processing.
  #
  class Blob
    attr_reader :site, :data

    def initialize(args = {})
      @site = args.delete(:site) { raise ::ArgumentError.new 'Argument `:site` required.' }
      @data = ::ActiveSupport::HashWithIndifferentAccess.new args.delete(:data)
    end

    # Return a the relative URL the blob should have in
    # generated site. The URL is based on the URL template
    # where placeholders are replaced with values from
    # blob data.
    #
    def relative_url
      url_template.gsub /:([^\/]+)/ do |match|
        data[match[1..-1]]
      end
    end

    # Return a URL template that may contain placeholder
    # referring to data values.
    #
    # Example:
    #   /blog/:year/:month/:slug/
    #
    def url_template
      raise ::NotImplementedError.new "#{self.class.name}#url_template not implemented."
    end

    # Return the site relative target path.
    #
    # The relative target path must be based on the URL.
    #
    # Example:
    #   A blob with the URL of `/2013/12/a-blog-post/`
    #   should have the relative target path of e.g.
    #   `/2013/12/a-blog-post/index.html`.
    #
    # The default blob relative target path will be derived
    # from the relative URL. If the relative URL ends with
    # a slash a `index.html` will be added.
    #
    def relative_target_path
      relative_url[-1] == '/' ? "#{relative_url}index.html" : relative_url
    end

    # Return full target path.
    #
    def target_path
      site.target.join ::Stic::Utils.without_leading_slash relative_target_path
    end

    # Return processed blob content as it can e.g. can be
    # written to file.
    #
    def render
      raise ::NotImplementedError.new "#{self.class.name}#render not implemented."
    end

    # Write blob to file.
    #
    # The filename must be derived from the URL based on
    # the URL template.
    #
    def write
      unless ::File.directory? (dir = ::File.dirname(target_path))
        FileUtils.mkdir_p dir
      end

      ::File.open target_path, 'w' do |file|
        file.write render
      end
    end

    def inspect
      "#<#{self.class.name}:#{object_id} #{relative_url}>"
    end
  end
end
