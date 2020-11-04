Pod::Spec.new do |s|
  s.name = 'Restler'
  s.version = '1.0.1'
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

  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.dependency 'RestlerCore', '~> 1.0.1'
  end

  # RxRestler
  s.subspec 'Rx' do |ss|
    ss.dependency 'Restler/Core'
    ss.dependency 'RxRestler', '~> 1.0.1'
  end
end
