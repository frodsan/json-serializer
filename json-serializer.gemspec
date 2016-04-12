Gem::Specification.new do |s|
  s.name        = "json-serializer"
  s.version     = "0.0.9"
  s.summary     = "Customize JSON ouput through serializer objects"
  s.description = s.summary
  s.author      = "Francesco Rodríguez"
  s.email       = "frodsan@protonmail.ch"
  s.homepage    = "https://github.com/frodsan/json-serializer"
  s.license     = "MIT"

  s.files      = Dir["LICENSE", "README.md", "lib/**/*.rb"]
  s.test_files = Dir["test/**/*.rb"]

  s.add_development_dependency "minitest", "~> 5.8"
  s.add_development_dependency "minitest-sugar", "~> 2.1"
  s.add_development_dependency "rake", "~> 11.0"
  s.add_development_dependency "rubocop", "~> 0.39"
end
