# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wisebedclientruby/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marvin Frick"]
  gem.email         = ["frick@informatik.uni-luebeck.de"]
  gem.description   = %q{Ruby gem to access the wisebed API via REST and websockets}
  gem.summary       = %q{Ruby gem to access the wisebed API via REST and websockets}
  gem.homepage      = "https://github.com/MrMarvin/wisebedclient-ruby"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "wisebedclientruby"
  gem.require_paths = ["lib"]
  gem.version       = Wisebedclient::VERSION
end
