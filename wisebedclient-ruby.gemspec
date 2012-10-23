# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wisebedclient-ruby/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marv Cool"]
  gem.email         = ["marv@hostin.is"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "wisebedclient-ruby"
  gem.require_paths = ["lib"]
  gem.version       = Wisebedclient::Ruby::VERSION
end
