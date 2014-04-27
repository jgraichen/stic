module Stic::Metadata

  # The BlockCommentYaml front matter parses YAML meta data
  # from an block comment at the beginning of a page:
  #
  # ```
  # /**
  #  * title: An Example
  #  */
  # ```
  #
  # ```
  # /*
  # title: An Example
  # */
  # ```
  #
  # ```
  # /* title: An Example */
  # ```
  #
  class BlockCommentYaml < ::Stic::Metadata::Yaml

    BLOCK_COMMENT_YAML_REGEXP = \
      %r{\A/\**\s*(?<data>.*?\n?)(\s*\*/\s*(\n|$)|^\s*\*/)(?<content>.*)\z}m

    def regexp
      BLOCK_COMMENT_YAML_REGEXP
    end

    def preprocess_data(blob, data)
      data.gsub(/^\s*\*/, "\n")
    end
  end

  ::Stic::Metadata.parsers << BlockCommentYaml.new
end
