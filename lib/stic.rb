require 'active_support/core_ext'
require 'active_support/concern'
require 'tilt'
require 'rubypath'

require 'stic/version'

module Stic
  # Utilities
  require 'stic/utils'

  # Logic modules
  require 'stic/layoutable'
  require 'stic/renderable'
  require 'stic/metadata'

  # Core classes
  require 'stic/blob'
  require 'stic/config'
  require 'stic/file'
  require 'stic/generator'
  require 'stic/page'
  require 'stic/site'

  module Generators
    require 'stic/generators/static'
    require 'stic/generators/page'
  end

  module Metadata
    require 'stic/metadata/parser'
    require 'stic/metadata/yaml'
    require 'stic/metadata/html_yaml'
  end
end
