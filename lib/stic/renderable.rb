module Stic

  # Provide functionality to render content using
  # Tilt with multiple engines.
  #
  module Renderable

    def render
      templates = Tilt.templates_for name
      output    = self.content.to_s

      Tilt.templates_for(name).each do |engine|
        output = engine.new{ output }.render(render_context, render_locals)
      end

      output
    end

    # Return render context.
    #
    def render_context
      self
    end

    # Return variables that should be available as locals
    # in render context.
    #
    def render_locals
      {}
    end
  end
end
