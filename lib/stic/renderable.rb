module Stic
  #
  # Provide functionality to render content using
  # Tilt with multiple engines.
  #
  module Renderable
    #
    # Return rendered content.
    #
    def render
      renderer.render(self)
    end

    def renderer
      @renderer ||= begin
        Renderer.new(self)
      end
    end

    # Return the file name for rendering. Should include all
    # file extensions to determine the template engines.
    #
    def render_name
      name
    end

    # Return variables that should be available as locals
    # in render context.
    #
    def locals
      {site: site, page: self}
    end
  end
end
