# -*- encoding: utf-8 -*-
require File.expand_path('../lib/candidate/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dylan Egan"]
  gem.email         = ["dylanegan@gmail.com"]
  gem.description   = %q{Manifesto API client.}
  gem.summary       = %q{ManifestoAPIclient.}
  gem.homepage      = "https://github.com/dylanegan/candidate"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "candidate"
  gem.require_paths = ["lib"]
  gem.version       = Candidate::VERSION

  gem.add_development_dependency "minitest", "~> 2.12"
  gem.add_development_dependency "rake", "~> 0.9.2"
  gem.add_development_dependency "simplecov", "~> 0.6"

  gem.add_runtime_dependency "clamp", "~> 0.3.0"
  gem.add_runtime_dependency "multi_json", "~> 1.3"
  gem.add_runtime_dependency "rest-client", "~> 1.6"
end
