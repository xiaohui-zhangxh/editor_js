lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'editor_js/version'

Gem::Specification.new do |spec|
  spec.name          = 'editor_js'
  spec.version       = EditorJs::VERSION
  spec.authors       = ['xiaohui']
  spec.email         = ['xiaohui@tanmer.com']

  spec.summary       = 'Ruby gem for editorjs.io text editor'
  spec.description   = 'It validates, parses, and renders content from editorjs'
  spec.homepage      = 'https://github.com/xiaohui-zhangxh/editor_js'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'actionview', '~> 6.1.7.6'
  spec.add_dependency 'activesupport', '~> 6.1.7.6'
  spec.add_dependency 'commonmarker', '~> 0.23.10'
  spec.add_dependency 'htmlentities', '~> 4.3', '>= 4.3.4' # latest
  spec.add_dependency 'json-schema', '~> 3.0.0'
  spec.add_dependency 'rouge', '~> 3.26'  # cannot update higher due to ruby support higher of 2.7
  spec.add_dependency 'sanitize', '~> 6.1'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
