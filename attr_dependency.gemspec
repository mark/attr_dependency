Gem::Specification.new do |s|
  s.name        = 'attr_dependency'
  s.version     = '0.1'
  s.date        = '2013-07-21'
  s.summary     = "A compromise between dependency injection and factory methods"
  s.description = <<-END
    Dependency Injection is becoming more popular in Ruby,
    despite not being required to solve the problems that
    dependency injection is designed to solve. Yet stubbing
    out factory methods in tests doesn't feel like the right
    solution either.  This gem represents a middle road.
  END
  s.authors     = ["Mark Josef"]
  s.email       = 'McPhage@gmail.com'
  s.files       = ["lib/attr_dependency.rb"]
  s.homepage    = "http://github.com/mark/attr_dependency"
end
