module Stic
  #
  class Config < Hashie::Mash
    include Hashie::Extensions::DeepMerge
    include Hashie::Extensions::DeepFetch

    attr_reader :files

    def initialize(options = {})
      @files = []

      super options
    end

    def load(file)
      data = ::YAML.load(file.read) if file.exist?
      deep_merge!(data) if data.is_a?(Hash)
      files << file
    end

    class << self
      def load(file)
        new.tap{|c| c.load file }
      end
    end
  end
end
