module Stic

  #
  #
  class Utils
    class << self
      def with_trailing_slash(path)
        path[-1] == '/' ? path : "#{path}/"
      end

      def with_leading_slash(path)
        path[0]== '/' ? path : "/#{path}"
      end

      def without_leading_slash(path)
        path.to_s.sub /^[\/]+/, ''
      end
    end
  end
end
