require 'thor'

module Stic

  #
  class CLI < ::Thor
    package_name 'stic'

    desc 'build', 'Build site'
    def build
      unless (site = Stic::Site.lookup)
        puts 'Not in a stic site. You need to run the ' \
             '`stic` command within a stic site.'
        exit 1
      end

      require 'bundler/setup'
      Bundler.require :default

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
