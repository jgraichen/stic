module Stic
  #
  # = Stic::Blob
  #
  # A {Blob} represents a single input or output element.
  # It does not assume any specific source or processing.
  #
  # Blob provides the basic functionality {Site} expects
  # for managing and writing blobs. Blob should not be used
  # directly but sub-classed. Include additional modules
  # to e.g. construct #{Readable} and #{Writable} blobs.
  #
  # See {File} for a simple blob implementation serving a
  # static file or {Page} for a more future rich example
  # including rendering.
  #
  class Blob
    #
    # @!group Attributes

    # The {Site} object.
    #
    # @return [Site] {Site} object.
    #
    attr_reader :site

    # A hash of additional meta data.
    #
    # The blob does not assume, process or load any kind of meta data.
    #
    # @return [HashWithIndifferentAccess] Meta data hash.
    #
    attr_reader :data

    # @!group Construction

    # Initialize new blob.
    #
    # @param opts [Hash] Initialization options.
    # @option opts [Site] :site *Required* Site object.
    # @option opts [Hash] :data Optional meta data hash.
    #
    def initialize(opts = {})
      @site = opts.delete(:site) { raise ::ArgumentError.new 'Argument `:site` required.' }
      @data = ::ActiveSupport::HashWithIndifferentAccess.new opts.delete(:data)
    end

    def inspect
      "#<#{self.class.name}:#{object_id}>"
    end
  end
end
