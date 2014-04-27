module Stic::Metadata

  # The HtmlYaml front matter parses YAML meta data from
  # an HTML comment at the beginning of a page:
  #
  # ```
  # <!--
  # title: An Example
  # --><html>...
  # ```
  #
  # ```
  # <!-- title: An Example -->
  # <html>...
  # ```
  #
  class HtmlYaml < ::Stic::Metadata::Yaml

    HTML_YAML_REGEXP = /\A<!--\s*(?<data>.*?\n?)(-->\s*(\n|$)|^-->\s*\n?)(?<content>.*)\z/m

    def regexp
      HTML_YAML_REGEXP
    end
  end

  ::Stic::Metadata.parsers << HtmlYaml.new
end
