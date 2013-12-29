source "https://rubygems.org"

group :development do
  gem 'rake'
  gem 'guard-rspec'
  gem 'listen'
end

group :test do
  gem 'rspec', '>= 3.0.0.beta1', '< 4'
  gem 'fakefs', require: 'fakefs/safe'
end

platform :rbx do
  gem 'rubysl'
end

# Specify your gem's dependencies in stic.gemspec
gemroot = File.dirname File.absolute_path __FILE__
gemspec path: gemroot
