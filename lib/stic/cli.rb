require 'opt'

module Stic
  #
  module CLI
    class << self
      def parser
        @opt ||= ::Opt.new.tap do |opt|
          opt.option '--help, -h'
          opt.option '--version, -v'
        end
      end

      def run(argv)
        result = parser.parse(argv)

        if result.version
          $stdout.puts "stic v#{Stic::VERSION}"
          exit 0
        elsif result.help
          help
          exit 0
        else
          result.command.shift.run(result)
        end
      end

      def help
        $stdout.puts <<-EOF.gsub(/^ {10}/, '')
          NAME
                stic - The static site generator. v#{Stic::VERSION}

          SYNOPSIS
                stic [command] [options]

          DESCRIPTION
                stic is a static site generation tool used to generate a set
                of styled and linked HTML pages from different sources
                like markdown.

          GLOBAL OPTIONS
                --help, -h
                    Print this help text.
                --version, -v
                    Print stic version.

          COMMANDS
EOF
        parser.commands.each do |command|
          $stdout.puts command.to_help
        end
      end

      require 'stic/cli/command'

      ::Dir[::File.expand_path('../cli/commands/*.rb', __FILE__)].each do |file|
        require file
      end
    end
  end
end
