platform :ios, '8.0'

pod 'HockeySDK', '~> 3.6', :inhibit_warnings => true
pod 'ReactiveCocoa', '~> 2.4.7'
pod 'Mixpanel', '~> 2.7', :inhibit_warnings => true

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'OCMock'
  pod 'OHHTTPStubs'
end

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'Resources/Other-Sources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
