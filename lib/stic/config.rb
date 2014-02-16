module Stic

  #
  #
  class Config
    attr_reader :options, :files
    delegate :[], to: :@options

    def initialize(options = {})
      @options = options
      @files   = []
    end

    def load(file)
      options.deep_merge ::YAML.safe_load file.read
      files << file
    end

    class << self
      def load(file)
        self.new.tap{ |c| c.load file }
      end
    end
  end
end
