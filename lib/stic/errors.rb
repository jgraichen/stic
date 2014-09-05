module Stic
  class Error < StandardError
    attr_reader :cause

    def initialize(opts = {})
      @cause = opts.fetch :cause, $!

      super opts.fetch(:message) { self.message }
    end
  end

  class BlobError < Error
    attr_reader :blob

    def initialize(opts = {})
      @blob = opts.fetch :blob, nil

      super opts
    end
  end

  class InvalidMetadata < BlobError
    def message
      "Invalid metadata in #{blob.to_s}: (#{cause.class}) #{cause.message}"
    end
  end
end
