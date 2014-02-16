require 'rspec'

if ENV['CI'] || ENV['COVERAGE']
  require 'coveralls'
  Coveralls.wear! do
    add_filter 'spec'
  end
end

# Load stic
require 'stic'

# Load spec support files
Dir[File.expand_path('spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  # Random order
  config.order = 'random'

  # Raise errors for old :should expectation syntax.
  config.raise_errors_for_deprecations!

  config.around(:each) do |example|
    Path::Backend.mock &example
  end
end
