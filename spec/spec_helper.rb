# Load dependencies
require 'bundler'
Bundler.require

# Load stic
require 'stic'

# Load spec support files
Dir[File.expand_path('spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  # Random order
  config.order = 'random'

  # Only allow expect syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
