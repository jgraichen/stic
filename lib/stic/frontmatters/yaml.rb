module Stic::Frontmatters

  # The YAML frontmatter is an frontmatter parser
  # providing capabilities to parse YAML embraced by
  # three dashes. Example:
  #
  # ---
  # title: An Example
  # ---
  #
  class Yaml < ::Stic::Frontmatter

    DASHED_YAML_REGEXP = /\A(?<data>---?\s*\n.*?\n?)^(---\s*$\n?)(?<content>.*)\z/m

    # Return Regexp to match YAML frontmatter and content.
    # Must provide two named match groups named `data` and
    # `content`.
    def regexp
      DASHED_YAML_REGEXP
    end

    def parse(file, blob)
      if (match = regexp.match(blob))
        self.data    = ::YAML.safe_load(match[:data])
        self.content = match[:content]

        true
      else
        false
      end
    end
  end

  ::Stic::Frontmatter.parsers << Yaml
end
