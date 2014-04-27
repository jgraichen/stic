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
      data = ::YAML.load(file.read) if file.exist?
      options.deep_merge(data) if data.is_a?(Hash)
      files << file
    end

    class << self
      def load(file)
        new.tap{|c| c.load file }
      end
    end
  end
end
