platform :ios, '8.0'

pod 'FormatterKit/LocationFormatter'
pod 'HockeySDK', '~> 3.6.2'

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Specta', :git => 'https://github.com/specta/specta.git', :tag => 'v0.3.0.beta1'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs'
end
