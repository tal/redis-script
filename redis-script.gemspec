# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis/script/version'

Gem::Specification.new do |gem|
  gem.name          = "redis-script"
  gem.version       = Redis::Script::VERSION
  gem.authors       = ["Tal Atlas"]
  gem.email         = ["me@tal.by"]
  gem.description   = %q{A library for loading and setting scripts into redis}
  gem.summary       = %q{A library for loading and setting scripts into redis}
  gem.homepage      = "https://github.com/tal/redis-script"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("redis",">= 3.0")

  gem.add_development_dependency('rspec')
end
