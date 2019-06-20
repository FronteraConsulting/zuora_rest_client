# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zuora_rest_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'zuora_rest_client'
  spec.version       = ZuoraRestClient::VERSION
  spec.authors       = ['David Massad']
  spec.email         = ['david.massad@fronteraconsulting.net']

  spec.summary       = 'Zuora REST Client'
  spec.description   = 'An easy-to-use client for Zuora.'
  spec.homepage      = 'https://github.com/FronteraConsulting/zuora_rest_client'
  spec.license       = 'MIT'

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'dotenv', '~> 2.2', '>= 2.2.1'
  spec.add_development_dependency 'simplecov', '~> 0.14.1'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'http-cookie', '~> 1.0', '>= 1.0.3'

  spec.add_runtime_dependency 'httpclient', '~> 2.8'
  spec.add_runtime_dependency 'faraday', '~> 0'
  spec.add_runtime_dependency 'faraday-detailed_logger', '~> 2'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0'
  spec.add_runtime_dependency 'multipart-post', '~> 2'
  spec.add_runtime_dependency 'addressable', '~> 2', '>= 2.5.1'
  spec.add_runtime_dependency 'fire_poll', '~> 1.2'
  spec.add_runtime_dependency 'multi_json', '~> 1.12', '>= 1.12.1'
  spec.add_runtime_dependency 'nori', '~> 2.6'
  spec.add_runtime_dependency 'nokogiri', '~> 1'
  spec.add_runtime_dependency 'recursive-open-struct', '~> 1', '>= 1.0.4'
  spec.add_runtime_dependency 'activesupport', '>= 0'

end
