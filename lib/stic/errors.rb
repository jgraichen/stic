module Stic
  module Error
    def self.prepended(base)
      base.send :attr_reader, :cause
    end

    def initialize(*args)
      @cause = args.pop if args.last.is_a?(Exception)
      @cause = args.last.fetch(:cause, nil) if args.last.is_a?(Hash)
      @cause ||= $!

      super *args
    end
  end

  module BlobError
    def self.prepended(base)
      base.send :attr_reader, :blob
    end

    def initialize(*args)
      @blob = args.last.is_a?(Hash) ? args.last.fetch(:blob, nil) : nil
      super *args
    end
  end

  class InvalidMetadata < StandardError
    prepend BlobError
    prepend Error

    def initialize(*args)
      super "Invalid metadata in #{blob.to_s}: (#{cause.class}) #{cause.message}"
    end
  end
end
