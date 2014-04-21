module Stic
  #
  # = Stic::SiteBase
  #
  # Base module for all site objects.
  #
  module SiteBase
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
  end
end
