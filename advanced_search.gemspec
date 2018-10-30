lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "advanced_search/version"

::Gem::Specification.new do |spec|
  spec.name          = "advanced_search"
  spec.version = ::AdvancedSearch.gem_version
  spec.licenses = ['AGPL-3.0']
  spec.authors       = ["Jared Beck"]
  spec.email         = ["jared@jaredbeck.com"]
  spec.homepage = 'https://github.com/jaredbeck/advanced_search'
  spec.summary       = "Database query builder for advanced search"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "activerecord", "~> 5.2"
  spec.add_development_dependency "bundler", "1.15.2"
  spec.add_development_dependency "byebug", "~> 10.0"
  spec.add_development_dependency "pg", "~> 1.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
