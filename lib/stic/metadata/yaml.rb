require 'yaml'

module Stic::Metadata

  # The YAML front matter is parses YAML meta data embraced
  # in three dashes from the beginning of a file. Example:
  #
  # ---
  # title: An Example
  # ---
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

    def preprocess_data(data)
      data
    end

    def preprocess_content(content)
      content
    end

    def match(blob)
      regexp.match(blob)
    end

    def parse(file, blob)
      if (match = match(blob))
        begin
          [
            ::YAML.load(preprocess_data(match[:data])),
            preprocess_content(match[:content])
          ]
        rescue Psych::SyntaxError
          nil
        end
      end
    end
  end

  ::Stic::Metadata.parsers << Yaml.new
end
