module Stic

  #
  class Generator
    attr_reader :site

    def initialize(site)
      @site = site
    end

    def name
      self.class.name.gsub(/Generator$/, '').underscore
    end

    def config
      @config ||= ::ActiveSupport::HashWithIndifferentAccess.new site.config.options[name] || {}
    end

    def run
      raise NotImplementedError.new "#{self.class.name}#run not implemented."
    end
  end
end
