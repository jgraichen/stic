require 'safe_yaml'
require 'active_support/core_ext'
require 'stic/version'
require 'stic/core_ext/all'

module Stic
  require 'stic/blob'
  require 'stic/config'
  require 'stic/file'
  require 'stic/generator'
  require 'stic/page'
  require 'stic/site'
  require 'stic/utils'

  module Generators
    require 'stic/generators/static'
  end
end
