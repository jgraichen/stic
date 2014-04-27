module Stic

  #
  #
  class Page < File
    include ::Stic::Renderable
    include ::Stic::Metadata
    include ::Stic::Layoutable

    def url_template
      path.replace_extensions(target_extension).as_absolute
    end

    def target_extension
      return data[:format] if data.key?(:format)
      case path.extensions.first
        when 'css', 'scss', 'sass', 'styl', 'less'
          'css'
        when 'js', 'coffeescript'
          'js'
        else
          'html'
      end
    end

    def default_layout
      if target_extension == 'html'
        super
      else
        nil
      end
    end
  end
end
