#
# Be sure to run `pod lib lint checkoutSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BudPay'
  s.version          = '1.0.1'
  s.summary          = 'An iOS-native wrapper for BudPay Checkout'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/korneliosyaovi/CheckoutSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dextr24' => 'korneliosyaovi@gmail.com' }
  s.source           = { :git => 'https://github.com/korneliosyaovi/CheckoutSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '5.0'
  s.ios.deployment_target = '15.0'

  s.source_files = 'checkoutSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'checkoutSDK' => ['checkoutSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
