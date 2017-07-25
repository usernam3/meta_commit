# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meta_commit/version'

Gem::Specification.new do |spec|
  spec.name          = "meta_commit"
  spec.version       = MetaCommit::VERSION
  spec.authors       = ["Stanislav Dobrovolskiy","Vitalii Shwetz"]
  spec.email         = ["uusername@protonmail.ch","vitsw86@gmail.com"]

  spec.summary       = %q{Enrich commit diffs with programing language insights}
  spec.homepage      = "https://github.com/usernam3/meta_commit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rugged", "~> 0.25"
  spec.add_runtime_dependency "parser", "~> 2.4"
  spec.add_runtime_dependency "thor", "~> 0.19"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "rspec-mocks", "~> 3.6"
  spec.add_development_dependency "byebug", "~> 9.0"
  spec.add_development_dependency "coveralls", "~> 0.8"
end
