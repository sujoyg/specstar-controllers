Gem::Specification.new do |s|
  s.name        = 'specstar-controllers'
  s.version     = '0.2.1'
  s.date        = Time.now.to_date
  s.summary     = 'RSpec helpers for controllers.'
  s.authors     = ['Sujoy Gupta']
  s.email       = 'sujoyg@gmail.com'
  s.files       = ['lib/specstar/controllers.rb']
  s.homepage    = 'http://github.com/sujoyg/specstar-controllers'

  s.add_development_dependency 'rspec-core', '~> 3.1'
end
