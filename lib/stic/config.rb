module Stic

  #
  #
  class Config
    attr_reader :options, :files

    def initialize
      @options = {}
      @files   = []
    end

    def load(file)
      options.deep_merge ::YAML.safe_load_file file
      files << file
    end

    class << self
      def load(file)
        self.new.tap{ |c| c.load file }
      end
    end
  end
end
