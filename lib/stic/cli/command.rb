module Stic
  module CLI
    #
    class Command < ::Opt::Command
      def run(_result)
        raise NotImplementedError.new "Subclass #{self.class.name} to " \
                                      'implement custom command.'
      end

      def site
        @site ||= begin
          Stic::Site.lookup.tap do |site|
            unless site
              puts 'Not in a stic site. You need to run the ' \
                   '`stic` command within a stic site.'
              exit 1
            end
          end
        end
      end

      def to_help
        <<-EOF.gsub(/^ {4}/, '')
          build
              Build current side ot given output path.

              --target, -t
                  Output path the side will be written to. Existing files
                  will be overriden and/or deleted. Defaults to `site`
                  in project root. (Not yet supported)
        EOF
      end

      class << self
        def define(name, &block)
          CLI.parser.commands << new(name).tap do |cmd|
            cmd.instance_eval(&block)
          end
        end
      end
    end
  end
end
