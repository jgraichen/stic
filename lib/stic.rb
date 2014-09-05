require 'active_support'
require 'active_support/core_ext'
require 'tilt'
require 'rubypath'
require 'yaml'
require 'mime/types'

require 'stic/version'

module Stic
  # Utilities
  require 'stic/utils'
  require 'stic/errors'

  # Logic modules
  require 'stic/layoutable'
  require 'stic/readable'
  require 'stic/renderable'
  require 'stic/metadata'
  require 'stic/site_base'

  # Core classes
  require 'stic/blob'
  require 'stic/config'
  require 'stic/file'
  require 'stic/generator'
  require 'stic/layout'
  require 'stic/page'
  require 'stic/renderer'
  require 'stic/site'

  module Generators
    require 'stic/generators/static'
    require 'stic/generators/page'
  end

  module Metadata
    require 'stic/metadata/parser'
    require 'stic/metadata/yaml'
    require 'stic/metadata/html_yaml'
    require 'stic/metadata/comment_yaml'
    require 'stic/metadata/block_comment_yaml'
  end
end
