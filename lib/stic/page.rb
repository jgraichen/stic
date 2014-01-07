module Stic

  #
  #
  class Page < File
    attr_reader :site, :source, :content

    include ::Stic::Renderable
    include ::Stic::Metadata
    include ::Stic::Layoutable

    def url_template
      ::Stic::Utils.with_leading_slash path.to_s.gsub(/\.[^\/]+$/, '.html')
    end
  end
end
