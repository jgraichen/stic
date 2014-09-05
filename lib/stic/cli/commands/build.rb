module Stic::CLI
  class Command::Build < Command
    define 'build' do
      option '--target, -t', nargs: 1
    end

    def run(_result)
      STDOUT.puts  " Configuration files: #{site.config.files.join(", ")}"
      STDOUT.puts  "              Source: #{site.source}"
      STDOUT.puts  "              Target: #{site.target}"
      STDOUT.print '       Generating ... '
      STDOUT.flush

      str_length = 0

      log = lambda do |str|
        STDOUT.print "\r                      " + ' ' * str_length
        STDOUT.print "\r                  ... #{str}"
        STDOUT.flush
        str_length = str.length
      end

      begin
        site.run {|generator| log.call "Running #{generator.class.name}" }
        site.write {|blob| log.call "Write #{blob.relative_url}" }
        site.cleanup
      rescue => e
        STDOUT.puts
        raise e
      end

      log.call 'done.'
      STDOUT.puts
    end
  end
end
