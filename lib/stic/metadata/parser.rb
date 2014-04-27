module Stic::Metadata

  # A Metadata::Parser can be used to parse metadata from
  # a file blob. This class defines the required interface
  # and can be used to derive specialized implementations.
  #
  class Parser

    # Parse given string blob. Return [data, content] if
    # blob parsing was successful or [nil, content]
    # otherwise.
    #
    # First argument will be corresponding file blob object
    # e.g. to check file extension if front matter is
    # restricted to specific file format.
    #
    def parse(blob, str)
      raise NotImplementedError.new "#{self.class.name}#parse must be implemented by subclass."
    end
  end
end
