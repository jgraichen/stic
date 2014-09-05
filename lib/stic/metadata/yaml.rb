require 'yaml'

module Stic::Metadata

  # The YAML front matter is parses YAML meta data embraced
  # in three dashes from the beginning of a file.
  #
  # @example
  #   ---
  #   title: An Example
  #   ---
  #
  class Yaml < ::Stic::Metadata::Parser

    DASHED_YAML_REGEXP =
      /\A(?<data>---?\s*\n.*?\n?)^(---\s*$\n?)(?<content>.*)\z/m

    # Return Regexp to match YAML frontmatter and content.
    # Must provide two named match groups named `data` and
    # `content`.
    def regexp
      DASHED_YAML_REGEXP
    end

    def preprocess_data(blob, data)
      data
    end

    def preprocess_content(blob, content)
      content
    end

    def match(blob, str)
      regexp.match(str)
    end

    def parse(blob, str)
      if (match = match(blob, str))
        begin
          [
            ::YAML.load(preprocess_data(blob, match[:data])),
            preprocess_content(blob, match[:content])
          ]
        rescue Psych::SyntaxError => err
          raise Stic::InvalidMetadata.new blob: blob
        end
      end
    end
  end

  ::Stic::Metadata.parsers << Yaml.new
end
