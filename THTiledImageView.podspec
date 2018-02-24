Pod::Spec.new do |s|
  s.name             = 'THTiledImageView'
  s.version          = '0.3.2.1'
  s.summary          = 'High Quality Image ScrollView using cropped tiled images.'

  s.description      = <<-DESC
                       Rendering High Quality Image from cropped tiled images.
                       You can set images by level and, render different images(normally smaller images) easily.
                       DESC

  s.homepage         = 'https://github.com/TileImageTeamiOS/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Changnam Hong' => 'hcn1519@gmail.com' }
  s.source           = { :git => 'https://github.com/TileImageTeamiOS/THTiledImageView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'THTiledImageView/THTiledImageView/*.swift'
  s.frameworks = 'UIKit'
  s.dependency 'Kingfisher'
end
