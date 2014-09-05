module Stic
  #
  class Post < Page
    FILENAME_REGEXP = /^(?<date>\d{4}-\d{2}-\d{2})-(?<slug>[\w\-]+)/

    def initialize(*args)
      super

      if (m = FILENAME_REGEXP.match(name))
        data[:date] = DateTime.parse data.fetch(:date, m[:date])
        data[:slug] = data.fetch(:slug, m[:slug])
      else
        data[:slug] = data.fetch(:slug, name.gsub(/[^A-z0-9]+/, '-').gsub(/^\-*|\-*$/, ''))
      end
    end

    def date
      data.fetch :date
    end

    def url_template
      Path site.config.fetch(:permalink, '/:year/:month/:slug/').to_s
    end

    def url_template_var(name)
      case name
      when 'year' then date.strftime('%Y')
      when 'month' then date.strftime('%m')
      else super
      end
    end

    def year
      date.year
    end

    def author
      site.config.authors.fetch data.fetch(:author)
    end

    def title
      data.fetch :title
    end

    def slug
      data.fetch :slug
    end

    def lang
      data.fetch(:lang) do
        site.config.fetch(:lang, 'en')
      end
    end

    def license
      data.fetch(:license) { site.config.fetch(:license, nil) }
    end
  end
end
