module Stic::Generators

  # The posts generators adds post blobs for each post from
  # define directory. Posts are like pages with additional
  # metadata like a date and an author.
  #
  # The source path for posts will be taken from
  # generator config key `path` and defaults to `./posts`.
  #
  # You can override the path in your site configuration:
  #
  #     generators:
  #       posts:
  #         path: ./custom_pages
  #
  class Posts < ::Stic::Generators::Static

    def path_default
      'posts'
    end

    def blob_class
      ::Stic::Post
    end
  end

  ::Stic::Site.generators << Posts
end
