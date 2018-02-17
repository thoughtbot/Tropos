platform :ios, '8.0'
plugin 'cocoapods-acknowledgements'

target 'Tropos' do
  pod 'HockeySDK', '~> 5.0', :inhibit_warnings => true
  pod 'ReactiveObjC', '~> 3.1'
  pod 'Mixpanel', '~> 2.7', :inhibit_warnings => true

  target 'UnitTests' do
    inherit! :search_paths
    pod 'OCMock'
    pod 'OHHTTPStubs'
  end
end
