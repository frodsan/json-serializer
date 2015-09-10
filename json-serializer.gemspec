Gem::Specification.new do |s|
  s.name        = "json-serializer"
  s.version     = "0.0.9"
  s.summary     = "Customize JSON ouput through serializer objects."
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez"]
  s.email       = ["frodsan@protonmail.ch"]
  s.homepage    = "https://github.com/harmoni/json-serializer"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "cutest", "~> 1.2"
end
