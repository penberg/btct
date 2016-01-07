unless defined? BTCT::VERSION
  $LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
  require 'btct/version'
end

Gem::Specification.new do |s|
  s.name        = 'btct'
  s.version     = BTCT::VERSION
  s.summary     = 'Bitcoin Terminal'
  s.description = 'Bitcoin terminal for monitoring real-time Bitcoin quotes on the command line.'
  s.authors     = ['Pekka Enberg']
  s.email       = 'penberg@iki.fi'
  s.files       = Dir[ 'README.md', 'bin/*', 'lib/**/*.rb' ]
  s.homepage    = 'https://github.com/penberg/btct'
  s.license     = 'MIT'

  s.executables << 'btct'

  s.add_runtime_dependency 'curses', '~> 1.0'
end
