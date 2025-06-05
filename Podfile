# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Sukbakji' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sukbakji

  pod 'KakaoSDKCommon'
  pod 'KakaoSDKAuth'
  pod 'KakaoSDKUser'

  pod 'Then'
  pod 'SnapKit', '~> 5.7.0'
  pod 'DropDown', '2.3.13'
  pod 'Tabman', '~> 3.0'
  pod 'FlexLayout'
  pod 'PinLayout'

  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'Alamofire'

  pod 'RxSwift', '6.8.0'
  pod 'RxCocoa', '6.8.0'
  pod 'ReactorKit'

end
post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
