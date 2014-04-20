module Stic
  #
  # Provide functionality to render content using
  # Tilt with multiple engines.
  #
  module Renderable
    #
    # Return rendered content.
    #
    def render(opts = {})
      render_content opts
    end

    # Render blob content without layout.
    #
    def render_content(opts = {})
      output  = content
      context = opts[:context] || Object.new
      locals  = opts[:locals]  || self.locals
      locals  = locals.merge(data: self.data)
      path    = source_path if respond_to?(:source_path)

      Tilt.templates_for(render_name).each do |engine|
        output = engine.new(path){ output.to_s }.render(context, locals) do
          opts[:parent].render_content(context: context, locals: locals)
        end
      end

      output.html_safe
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
      {site: site, config: site.config}
    end
  end
end
