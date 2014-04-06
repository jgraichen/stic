source 'https://rubygems.org'

gem 'rake'
gem 'rubypath', path: '~/workspace/ruby-path'

group :development do
  gem 'yard', '~> 0.8.6'
  gem 'listen'
  gem 'guard-yard'
  gem 'guard-rspec'
  gem 'redcarpet', platform: :ruby
end

group :test do
  gem 'rspec'
  gem 'coveralls'
end

platform :rbx do
  gem 'rubysl'
end

# Specify your gem's dependencies in stic.gemspec
gemroot = File.dirname File.absolute_path __FILE__
gemspec path: gemroot
