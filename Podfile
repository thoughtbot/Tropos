platform :ios, '8.0'
plugin 'cocoapods-acknowledgements', :settings_bundle => true

target 'Tropos' do
  pod 'HockeySDK', '~> 3.6', :inhibit_warnings => true
  pod 'ReactiveCocoa', '~> 2.4.7'
  pod 'Mixpanel', '~> 2.7', :inhibit_warnings => true

  target 'UnitTests' do
    inherit! :search_paths
    pod 'OCMock'
    pod 'OHHTTPStubs'
  end
end
