# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wisebedclient-ruby/version', __FILE__)


  gem.authors       = ["Marvin Frick"]
  gem.email         = ["frick@informatik.uni-luebeck.de"]
  gem.description   = %q{Ruby gem to access the wisebed API via REST and websockets}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "wisebedclient-ruby"
  gem.require_paths = ["lib"]
  gem.version       = Wisebedclient::VERSION
end
