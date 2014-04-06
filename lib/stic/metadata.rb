module Stic

  # A metadata front matter is data blob usual at the
  # beginning of a file. It contains additional meta
  # information that can be used when rendering the file
  # or by additional generators etc.
  #
  module Metadata
    def initialize(*args)
      super
      load_metadata
    end

    private

    def load_metadata
      data, @content = ::Stic::Metadata.parse(self, read)
      @data.merge! data if data
    end

    class << self
      def parsers
        @parsers ||= []
      end

      def parse(file, blob)
        parsers.each do |parser|
          metadata, content = parser.parse(file, blob)
          return [metadata, content] if metadata
        end
        [nil, blob]
      end
    end
  end
end
