platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

target 'YandexWeatherTest' do
  inherit! :search_paths

  pod 'Resolver'

  pod 'RxCocoa'
  pod 'RxSwift'

  pod 'SwiftGen'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end
