module Stic::Metadata

  # The CommentYaml front matter parses YAML meta data from
  # an line comment at the beginning of a page:
  #
  # ```
  # // title: An Example
  # // author: John
  # ```
  #
  # ```
  # # title: An Example
  # # author: John
  # ```
  #
  class CommentYaml < ::Stic::Metadata::Yaml

    def match(blob, str)
      if (m = %r{\A(\s*(//|#)\s*)(.+:.+)}.match(str))
        sep = m[1]
        case sep.strip
          when '#'
            return nil if %w(md markdown).include? blob.path.ext
        end

        scan_data str, sep
      end
    end

    def scan_data(str, sep)
      data, content = [], []
      str.each_line do |line|
        if !line.starts_with?(sep) .. false
          content << line
        else
          data << line[sep.length..-1]
        end
      end

      {data: data.join("\n"), content: content.join("\n")}
    end
  end

  ::Stic::Metadata.parsers << CommentYaml.new
end
