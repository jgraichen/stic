module Stic

  # A Generator generates blobs or specific subclasses
  # based on some input.
  #
  # As an example see Stic::Generators::Static that
  # generates blobs for static files.
  #
  # A generator will be initialized by the system and it's
  # `run` method will be invoked. The generator now can add
  # blobs to the `site`. Subclass must override the `run`
  # method providing custom logic.
  #
  class Generator
    attr_reader :site

    # Return generator specific configuration from site.
    # The configuration values are loaded from
    # `generators.<generator name>`.
    #
    attr_reader :config

    def initialize(site, config)
      @site   = site
      @config = ::ActiveSupport::HashWithIndifferentAccess.new (config && config[name]) || {}
    end

    # Return generator name. The name is derived from the
    # class name as an underscore string with `Generator`
    # striped from the end.
    #
    def name
      self.class.name.underscore.gsub(/_generator$/, '')
    end

    # Run this generator. This is the place to
    # implement custom logic and add blobs to the site.
    #
    # The `run` method must be implemented by a subclass.
    #
    def run
      raise NotImplementedError.new "#{self.class.name}#run not implemented."
    end

    def enabled?
      %w(true yes).includes? config['disable'].to_s
    end

    protected
    def log_msg(&block)
      # TODO
      # noop
    end
  end
end
