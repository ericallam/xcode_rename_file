# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcode_rename_file/version'

Gem::Specification.new do |spec|
  spec.name          = "xcode_rename_file"
  spec.version       = XcodeRenameFile::VERSION
  spec.authors       = ["Eric Allam"]
  spec.email         = ["eallam@icloud.com"]
  spec.summary       = %q{Easily rename files in an Xcode project from the command line}
  spec.description   = %q{Easily rename files in an Xcode project from the command line}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "xcodeproj", "~> 0.17.0"
  spec.add_dependency "mixlib-cli"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
