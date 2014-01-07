# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stic/version'

Gem::Specification.new do |spec|
  spec.name          = 'stic'
  spec.version       = Stic::VERSION
  spec.authors       = ['Jan Graichen']
  spec.email         = ['jg@altimos.de']
  spec.summary       = %q{Opinionated extensible static site generator.}
  spec.description   = %q{Still an opinionated extensible static site generator.}
  spec.homepage      = 'https://github.com/jgraichen/stic'
  spec.license       = 'AGPLv3'

  spec.files         = Dir['**/*'].grep(%r{^((bin|lib|spec)/|.*\.gemspec|.*LICENSE.*|.*README.*)})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'commander'
  spec.add_dependency 'tilt'
  spec.add_dependency 'activesupport', '>= 4'
  spec.add_dependency 'safe_yaml'

  spec.add_development_dependency 'bundler', '~> 1.3'
end
