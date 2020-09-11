Pod::Spec.new do |restler|
  restler.name = 'Restler'
  restler.version = '0.1.2'
  restler.summary = 'Framework for REST requests in Swift'
  restler.description = <<-DESC
    Restler is a framework for type-safe and easy REST API requests in Swift.
  DESC
  restler.homepage = 'https://github.com/railwaymen/restler'
  restler.license = { :type => 'MIT', :file => 'LICENSE'}
  restler.author = { 'Bartłomiej Świerad' => 'bartlomiej.swierad@railwaymen.org' }
  restler.source = { :git => 'https://github.com/railwaymen/restler.git', :tag => restler.version.to_s }
  restler.ios.deployment_target = '9.0'
  restler.swift_versions = '5.2'

  # Core
  restler.subspec 'Core' do |core|
    core.source_files = 'Sources/Restler/**/*'
  end

  # RxRestler
  restler.subspec 'Rx' do |component|
    component.source_files = 'Sources/RxRestler/**/*'
    component.dependency 'Restler/Core'
    component.dependency 'RxSwift', '~> 5.1.1'
  end
end
