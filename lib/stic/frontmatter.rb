module Stic

  # A Frontmatter is data blob usual at the beginning
  # of a file. It contains additional meta information
  # that can be used when rendering the file or by
  # additional generators etc.
  #
  class Frontmatter
    attr_accessor :data, :content

    # Parse given string blob. Return true if blob parsing
    # was successful and we can retrieve `data` and `content`.
    # Return false otherwise.
    #
    # First argument will be corresponding file blob object
    # e.g. to check file extension if front matter is
    # restricted to specific file format.
    #
    # Parsed meta data and content can be assigned using
    # `data` and `content` attribute writers.
    #
    def parse(file, blob)
      raise NotImplementedError.new "#{self.class.name}#parse must be implemented by subclass."
    end

    class << self
      def parsers
        @parsers ||= []
      end

      def parse(file, blob)
        self.parsers.each do |klass|
          parser = klass.new
          if parser.parse(file, blob)
            return parser
          end
        end
        false
      end
    end
  end
end
