platform :ios, '11.0'

target 'NearbyVenues' do
  use_frameworks!
  pod 'SBTUITestTunnelServer'
  pod 'GCDWebServer', :inhibit_warnings => true
   
  target 'NearbyVenuesTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  target 'NearbyVenuesUITests' do
      inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
    pod 'SBTUITestTunnelClient'
  end
end
