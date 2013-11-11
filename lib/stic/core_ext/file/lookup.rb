class File

  module Lookup
    # Tries to lookup a given file name or file pattern in
    # given directory and parent directories. If no
    # directory is given the current working directory will
    # be used.
    #
    # @param file [#to_s, Regexp] File or Regexp to look for.
    # @param dir [#to_s] Directory to start looking for file.
    # @return Found file path or nil.
    #
    def lookup(file, dir = Dir.pwd)
      dirs = File.expand_path(dir.to_s).split('/')
      while dirs.any?
        dir = File.join(*dirs)
        if Dir.exists? dir
          if file.is_a? Regexp
            Dir.entries(dir).each do |f|
              return File.join(dir, f) if f =~ file
            end
          else
            f = File.join(dir, file.to_s)
            return f if File.exists?(f)
          end
        end

        dirs.pop
      end
    end
  end

  extend Lookup
end
