Pod::Spec.new do |s|
  s.name             = "Tapstream-Segment"
  s.version          = "1.0.0"
  s.summary          = "Tapstream Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
                       This is the Tapstream integration for the iOS library for Segment.
                       DESC

  s.homepage         = "https://tapstream.com/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Adam Bard" => "adam@tapstream.com" }
  s.source           = { :git => "https://github.com/tapstream/analytics-ios-integration-tapstream.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TapstreamApp'

  s.ios.deployment_target = '6.0'

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Tapstream-Segment' => ['Tapstream-Segment/Assets/*.png']
  }

  s.dependency 'Analytics', '~> 3.0.0'
  s.dependency 'Tapstream', '~> 2.11.0'
end
