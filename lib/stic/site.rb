module Stic

  # The {Site} is the main class representing the hole site project.
  #
  # It contains the configuration, source and target paths and provides
  # all functionality to invoke {Generator}s, manage and access {Blob}s and
  # write the rendered site project.
  #
  # @example
  #   site = ::Stic::Site.lookup
  #   site.run
  #   site.write
  #
  class Site

    # @!group Attributes

    # The project's source path.
    #
    # @return [Path] The source path.
    #
    attr_reader :source

    # The project's target path.
    #
    # @return [Path] The target path.
    #
    attr_reader :target

    # The project's configuration object. Will be initialized with the values
    # loaded from configuration file found in project's source directory.
    #
    # @return [Config] The project configuration.
    #
    attr_reader :config

    # The list of initialized {Generator}s. They will be initialized within
    # the {#initialize} method.
    #
    # @return [Array<Generator>] Initialized {Generator} instances.
    #
    attr_reader :generators

    # @!group Construction

    # Initializes new {Site} object.
    #
    # @param source [String, Path] The source directory where the rendered site
    #   should be written to.
    # @param config [Config] The configuration that should be used. Usually
    #   loaded from configuration file located in the source directory.
    #
    def initialize(source, config)
      @config = config
      @source = Path.new source
      @target = Path.new(source).join('site').expand
      @blobs  = []

      @generators = self.class.generators.map do |generator_class|
        generator_class.new self, config['generators']
      end
    end

    # @!group Accessors

    # Return list of {Blob}s.
    #
    # You can pass a class as `:type` option that will be used to filter the
    # returned {Blob}s by Inheritance. Only {Blob}s of given class or {Blob}s
    # that inherit given class will be returned.
    #
    # @param opts [Hash] Option hash.
    # @option opts [Class] :type Class used as a filter.
    #
    def blobs(opts = {})
      return @blobs if opts[:type].nil?
      @blobs.select{|blob| blob.class <= opts[:type] }
    end

    # @!group Actions

    # Run all registered and initialized {Generator}s.
    #
    # A block can be passed that will be called before each {Generator} is run.
    #
    # @yield [generator] Called before given {Generator} will be run.
    # @yieldparam generator [Generator] {Generator} to be run next.
    #
    # @return [Self]
    #
    def run(&block)
      generators.each do |generator|
        block.call generator if block
        generator.run
      end

      self
    end

    # Write all added {Blob}s to their destination.
    #
    # A block can be passed that will be called before each {Blob} is written.
    #
    # @yield [blob] Called before given {Blob} will be written.
    # @yieldparam blob [Blob] {Blob} that will be written next.
    #
    # @return [Self]
    #
    def write(&block)
      blobs.each do |blob|
        block.call blob if block
        blob.write
      end

      self
    end

    # Cleanup target directory. That will remove all files and directories
    # not referenced by any {Blob}.
    #
    # @return [Self]
    #
    def cleanup
      paths = blobs.map(&:target_path)

      # Cleanup not longer referenced files
      target.glob('**/*').each do |path|
        if path.file? && !paths.include?(path)
          path.unlink
        elsif path.directory? && !paths.any?{|p| p.path.starts_with? path.to_s }
          path.rm_rf
        end
      end

      self
    end

    # Add new {Blob} to site.
    #
    # You should not add {Blob}s with same `target_url` or
    # `relative_target_path` as they later would override the previous file.
    #
    # @param blob [Blob] {Blob} to add.
    #
    def <<(blob)
      blobs << blob
    end

    class << self
      # Try to find a stic site in given directory or above.
      # If no directory is given the current working
      # directory will be used.
      #
      def lookup(dir = Path.getwd)
        file = Path.new(dir).lookup(/^stic.ya?ml$/)
        file ? new(file.dirname, Stic::Config.load(file)) : nil
      end

      # Return list of available generator classes.
      def generators
        @generators ||= []
      end
    end
  end
end
