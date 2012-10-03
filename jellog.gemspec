$LOAD_PATH.unshift 'lib'
require 'jellog/version'

Gem::Specification.new do |s|
  s.name              = "jellog"
  s.version           = Jellog::Version
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "A useful little logger"
  #s.homepage          = "http://github.com/#{login}/#{name}"
  s.email             = "robert@osburn-sharp.ath.cx"
  s.authors           = [ "Dr Robert" ]
  s.has_rdoc          = true

  s.files             = %w( README.txt History.txt LICENCE.txt Bugs.txt )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("doc/**/*")
  s.files            += Dir.glob("spec/**/*")
  s.files            += Dir.glob("test/**/*")
  
  s.add_dependency('colored')

#  s.executables       = %w( #{name} )
  s.description       = File.read("Intro.txt")
end