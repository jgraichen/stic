# Load dependencies
require 'bundler'
Bundler.require :default, :test

require 'fakefs/spec_helpers'
FakeFS::File.send :extend, File::Lookup

# Load stic
require 'stic'

# Load spec support files
Dir[File.expand_path('spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  # Random order
  config.order = 'random'

  config.include FakeFS::SpecHelpers

  # Only allow expect syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
