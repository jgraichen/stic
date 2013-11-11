module Stic

  #
  #
  class Utils
    class << self
      def ensure_trailing_slash(path)
        path[-1] == '/' ? path : "#{path}/"
      end

      def ensure_leading_slash(path)
        path[0]== '/' ? path : "/#{path}"
      end
    end
  end
end
