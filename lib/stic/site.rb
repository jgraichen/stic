module Stic

  #
  #
  class Site
    attr_reader :blobs, :source, :target, :config, :generators

    def initialize(source, config)
      @config = config
      @source = ::Pathname.new source
      @target = ::Pathname.new ::File.expand_path("site", source)
      @blobs  = []

      @generators = self.class.generators.map{ |g| g.new self }
    end

    def run
      generators.each{ |generator| generator.run }
    end

    def write
      blobs.each{ |blob| blob.write }
    end

    def cleanup
      paths = self.blobs.map(&:target_path).map(&:to_s)

      # Cleanup not longer referenced files
      Dir.glob(target.join('**/*')).each do |path|
        if ::File.file?(path) && !paths.include?(path)
          ::File.unlink path
          puts "Unlinked #{path}"
        elsif ::File.directory?(path) && !paths.any? { |p| p.starts_with? path }
          FileUtils.rm_rf path
          puts "Removed #{path}"
        end
      end
    end

    def <<(blob)
      blobs << blob
      STDOUT.puts "  Blob added: #{blob.inspect}"
    end

    class << self
      # Try to find a stic site in given directory or above.
      # If no directory is given the current working
      # directory will be used.
      #
      def lookup(dir = Dir.pwd)
        file = ::File.lookup /^stic.ya?ml$/
        file ? self.new(::File.dirname(file), Stic::Config.load(file)) : nil
      end

      # Return list of available generator classes.
      def generators
        @generators ||= []
      end
    end
  end
end
