Gem::Specification.new do |s|
  s.name        = "json-serializer"
  s.version     = "0.0.8"
  s.summary     = "Customize JSON ouput through serializer objects."
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez", "Mayn Kjær"]
  s.email       = ["frodsan@me.com", "mayn.kjaer@gmail.com"]
  s.homepage    = "https://github.com/harmoni/json-serializer"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "cutest"
end
