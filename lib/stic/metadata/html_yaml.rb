module Stic::Metadata

  # The HtmlYaml front matter parses YAML meta data from
  # an HTML comment at the beginning of a page:
  #
  # <!--
  # title: An Example
  # --><html>...
  #
  class HtmlYaml < ::Stic::Metadata::Yaml

    HTML_YAML_REGEXP = /\A<!--\s*\n(?<data>.*?\n?)^(-->\s*)(?<content>.*)\z/m

    def regexp
      HTML_YAML_REGEXP
    end
  end

  ::Stic::Metadata.parsers << HtmlYaml.new
end
