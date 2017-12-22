# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "grpc_for_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "grpc_for_rails"
  spec.version       = GrpcForRails::VERSION
  spec.authors       = ["Vincent"]
  spec.email         = ["xiewenwei@gmail.com"]

  spec.summary       = %q{Make grpc server and client easy for rails project.}
  spec.description   = %q{grpc_for_rails provides a useful grpc_server wrapper and some flexible generators and rake tasks for rails project.}
  spec.homepage      = "https://github.com/xiewenwei/grpc_for_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties', '>= 4.2.0'
  spec.add_dependency "grpc", "~> 1.2"
  spec.add_dependency 'grpc-tools', '~> 1.2'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
