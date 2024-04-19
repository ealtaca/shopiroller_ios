#
# Be sure to run `pod lib lint Shopiroller.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Shopiroller'
  s.version          = '0.2.40'
  s.summary          = 'Get your own eCommerce mobile app in minutes. Avoid all the coding & focus on user experience on Shopiroller iOS SDK'
  s.homepage         = 'https://github.com/shopiroller/shopiroller-uikit-ios'
  s.description      = 'Mobile e-commerce applications are now closer to your users with Shopiroller iOS SDK. It is now very easy to have your own mobile application. Our eCommerce mobile SDKs are readymade platforms to be taken over by you; accelerating your mobile app development process by months. It`s a head-start!'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ealtaca' => 'ealtaca@gmail.com' }
  s.swift_version    = "4.0"

  s.ios.deployment_target = '13.0'
  
  s.platform     = :ios, '13.0'
  
  s.source       = { :git => 'git@github.com:shopiroller/shopiroller-uikit-ios.git', :tag => s.version }
  s.source_files = "Shopiroller/**/*.{swift,xib,strings}", "Shopiroller/Fonts/*.{ttf}"
  
  s.resources = 'Shopiroller/Assets.xcassets', 'Shopiroller/Fonts/*.{ttf}' , 'Shopiroller/Animations/*.{json}'

  s.dependency 'SVProgressHUD'
  s.dependency 'MaterialComponents/Buttons'
  s.dependency 'FittedSheets', '~> 2.6.1'
  s.dependency 'Kingfisher' , '~> 7.1.2'
  s.dependency 'InputMask'
  s.dependency 'lottie-ios', '~> 3.5.0'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'Stripe', '~> 22.8.1'
  s.dependency 'Braintree', '~> 5.12.0'
  s.dependency 'Sentry', '~> 8.4.0'

end
