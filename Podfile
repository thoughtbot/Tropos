platform :ios, '8.0'

pod 'HockeySDK', '~> 3.6.2'
pod 'ReactiveCocoa', '~> 2.4.7'

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Specta', :git => 'https://github.com/specta/specta.git', :tag => 'v0.3.0.beta1'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs'
end
