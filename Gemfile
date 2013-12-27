source "https://rubygems.org"

group :development do
  gem 'rake'
  gem 'guard-rspec'
  gem 'listen'
end

group :test do
  gem 'rspec'
  gem 'fakefs', require: 'fakefs/safe'
end

# Specify your gem's dependencies in stic.gemspec
gemroot = File.dirname File.absolute_path __FILE__
gemspec path: gemroot
