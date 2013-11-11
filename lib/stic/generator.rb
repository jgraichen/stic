module Stic

  #
  class Generator
    attr_reader :site

    def initialize(site)
      @site = site
    end

    def generate
      raise NotImplementedError
    end
  end
end
