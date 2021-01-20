Pod::Spec.new do |s|
  s.name = 'Restler'
  s.version = '1.1.1'
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
  s.swift_versions = '5.2'

  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    s.ios.deployment_target = '9.0'
    ss.dependency 'RestlerCore', '~> 1.1'
  end

  # RxRestler
  s.subspec 'Rx' do |ss|
    s.ios.deployment_target = '9.0'
    ss.dependency 'Restler/Core'
    ss.dependency 'RxRestler', '~> 1.1'
  end

  # RestlerCombine
  s.subspec 'Combine' do |ss|
    s.ios.deployment_target = '13.0'
    ss.dependency 'Restler/Core'
    ss.dependency 'RestlerCombine', '~> 1.1'
  end
end
