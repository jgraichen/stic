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

    def match(blob)
      if blob =~ %r{\A(\s*(//|#)\s*)}
        sep = $1
        data, content = [], []
        blob.each_line do |line|
          if !line.starts_with?(sep) .. false
            content << line
          else
            data << line[sep.length..-1]
          end
        end

        {data: data.join("\n"), content: content.join("\n")}
      end
    end
  end

  ::Stic::Metadata.parsers << CommentYaml.new
end
