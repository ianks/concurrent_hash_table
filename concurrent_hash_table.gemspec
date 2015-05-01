# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'concurrent_hash_table/version'

Gem::Specification.new do |spec|
  spec.name          = "concurrent_hash_table"
  spec.version       = ConcurrentHashTable::VERSION
  spec.authors       = ["Ian Ker-Seymer"]
  spec.email         = ["i.kerseymer@gmail.com"]

  spec.summary       = 'A concurrent Hash table in Ruby'
  spec.description   = 'TODO: Write a longer description or delete this line.'
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
