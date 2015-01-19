# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'content_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "content_crawler"
  spec.version       = ContentCrawler::VERSION
  spec.authors       = ["Prakash Natarajan"]
  spec.email         = ["prakashntrjn@gmail.com"]
  spec.summary       = %q{Content crwaler}
  spec.description   = %q{This will be crawling data from websites. Need to give the xpaths clearly. Will be updating with new functionalities in future}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
