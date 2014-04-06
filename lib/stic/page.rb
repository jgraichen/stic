module Stic

  #
  #
  class Page < File
    attr_reader :site, :source, :content

    include ::Stic::Renderable
    include ::Stic::Metadata
    include ::Stic::Layoutable

    def url_template
      path.replace_extensions('html').as_absolute
    end
  end
end
