module Stic

  #
  #
  class Site
    attr_reader :files, :pages, :source, :target, :config

    def initialize(source, config)
      @config = config
      @source = ::Pathname.new source
      @target = ::Pathname.new ::File.expand_path("site", source)
      @pages  = []
      @files  = []

      load_files
    end

    def load_files
      Dir[source.join("files/**/*")].each do |file|
        if ::File.exists?(file) && ::Stic::File.valid?(file)
          self.files << Stic::File.new(self, ::File.dirname(file).gsub(source.to_s, ''), ::File.basename(file))
        end
      end
    end

    def write
      self.files.each do |file|
        file.write
      end
    end

    def cleanup
      paths = self.files.map(&:target_path).map(&:to_s)

      # Cleanup not longer referenced files
      Dir.glob(target.join('**/*')).each do |file|
        ::File.unlink(file) if ::File.file?(file) && !paths.include?(file)
      end

      # Cleanup empty directories not explicit references
      Dir.glob(target.join('**/*')).each do |dir|
        ::Dir.unlink(dir) if ::File.directory?(dir) && !::Dir.entries(dir).any?{|e| !%w(. ..).include? e} && !paths.include?(dir)
      end
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

      def lookup!
        site = self.lookup
        return site if site

        puts "Not in a stic site. You need to run the `stic` command within a stic site."
        exit 1
      end
    end
  end
end
