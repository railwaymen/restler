Pod::Spec.new do |s|
  s.name = 'RestlerCore'
  s.version = '1.1'
  s.summary = 'Framework for REST requests in Swift'
  s.description = <<-DESC
    Restler is a framework for type-safe and easy REST API requests in Swift.
  DESC
  s.homepage = 'https://github.com/railwaymen/restler'
  s.license = { :type => 'MIT', :file => 'LICENSE'}
  s.author = { 'Bartłomiej Świerad' => 'bartlomiej.swierad@railwaymen.org' }
  s.source = {
    :git => 'https://github.com/railwaymen/restler.git',
    :tag => s.version.to_s
  }
  s.ios.deployment_target = '9.0'
  s.swift_versions = '5.2'

  s.source_files = 'Sources/RestlerCore/**/*.swift'
end
