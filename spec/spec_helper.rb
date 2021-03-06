require 'rspec'

if ENV['CI'] || (defined?(:RUBY_ENGINE) && RUBY_ENGINE != 'rbx')
  require 'coveralls'
  require 'codeclimate-test-reporter'

  Coveralls.wear! do
    add_filter 'spec'
  end

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end

# Load stic
require 'stic'

# Load spec support files
Dir[File.expand_path('spec/support/**/*.rb')].each {|f| require f }

RSpec.configure do |config|
  # Random order
  config.order = 'random'

  config.around(:each) do |example|
    Path::Backend.mock(&example)
  end
end
