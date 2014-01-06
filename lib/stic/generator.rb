module Stic

  # A Generator generates blobs or specific subclasses based on some input.
  #
  # As an example see {Stic::Generators::Static} that generates blobs for
  # static files.
  #
  # A generator will be initialized by the system and it's
  # {#run} method will be invoked. The generator now can add
  # blobs to the `site`. Subclass must override the {#run}
  # method providing custom logic.
  #
  class Generator

    #!@group Attributes

    # The {Site} object.
    #
    # @return [Site] {Site} object.
    #
    attr_reader :site

    # The generator specific configuration.
    # The values are passed from {Site} and are loaded from
    # `generators.<generator name>`.
    #
    # @return [HashWithIndifferentAccess] Option hash.
    #
    attr_reader :config

    #@!group Construction

    # Initialize new {Generator}.
    #
    # @param site [Site] {Site} object.
    # @param config [Hash] Hash object containing options for all generators.
    #   The generator picks it own options from the passed hash based on the
    #   generator's {#name}.
    #
    def initialize(site, config)
      @site   = site
      @config = ::ActiveSupport::HashWithIndifferentAccess.new (config && config[name]) || {}
    end

    #@!group Accessors

    # Return generator name. The name is derived from the class name as an
    # underscore string with `_generator` striped from the end.
    #
    # @return [String] Generator name.
    #
    def name
      self.class.name.underscore.gsub(/_generator$/, '')
    end

    # Check if generator is disabled.
    #
    # A generator can be disabled by setting the generator's `disable`
    # configuration key to either 'true' or 'yes'.
    #
    # @return [Boolean] True unless generator is disabled.
    #
    def disabled?
      %w(true yes).includes? config['disable'].to_s
    end

    #@!group Actions

    # Run this {Generator}. This is the place to implement custom logic and
    # add {Blob}s to the site.
    #
    # The {#run} method must be implemented by a subclass.
    #
    def run
      raise NotImplementedError.new "#{self.class.name}#run not implemented."
    end

    protected

    # Log a message to the site generation log. The message will be prefixed
    # with the generator name. The message must be passed as a block that
    # will be yielded when logging is enabled, has the required log level
    # or is otherwise not disabled globally or for this generator.
    #
    # @yield Block to retrieve log message.
    #
    def log_msg(&block)
      # TODO
      # noop
    end
  end
end
