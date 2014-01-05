module Stic::Frontmatters

  # The YAML frontmatter is an frontmatter parser
  # providing capabilities to parse YAML embraced by
  # three dashes. Example:
  #
  # ---
  # title: An Example
  # ---
  #
  class HtmlYaml < ::Stic::Frontmatters::Yaml

    HTML_YAML_REGEXP = /\A<!--\s*\n(?<data>.*?\n?)^(-->\s*)(?<content>.*)\z/m

    def regexp
      HTML_YAML_REGEXP
    end
  end

  ::Stic::Frontmatter.parsers << HtmlYaml
end
