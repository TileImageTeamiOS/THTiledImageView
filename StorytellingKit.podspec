Pod::Spec.new do |s|
  s.name             = 'StorytellingKit'
  s.version          = '0.1.1'
  s.summary          = 'High Quality Image ScrollView with storytelling contents.'

  s.description      = <<-DESC
                       ImageScrollView with various content marker for Storytelling.
                       High Quality Image can be rendered by tiled Image. Text, Audio, and Video can be added by marker.
                       DESC

  s.homepage         = 'https://github.com/TileImageTeamiOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Changnam Hong' => 'hcn1519@gmail.com' }
  s.source           = { :git => 'https://github.com/TileImageTeamiOS/StorytellingKit.git', :tag => s.version.to_s }


  s.ios.deployment_target = '9.0'
  s.source_files = 'MyTileImageViewer/TileImageView/*.swift'
  s.frameworks = 'UIKit'

end
