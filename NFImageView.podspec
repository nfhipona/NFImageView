#
# Be sure to run `pod lib lint NFImageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NFImageView'
  s.version          = '0.1.6'
  s.summary          = "'NFImageView' is a subclass of a UIView that acts like a UIImageView. Uses CoreGraphics to draw image."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC

"NFImageView is a like UIImageView that has loading indicator built within it to indicate that there an active loading of an image. It has an option for loading style. A progress bar or a spinner."

                       DESC

  s.homepage         = 'https://github.com/nferocious76/NFImageView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Neil Francis Ramirez Hipona' => 'nferocious76@gmail.com' }
  s.source           = { :git => 'https://github.com/nferocious76/NFImageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/nferocious76'

  s.ios.deployment_target = '9.0'

  s.source_files = 'NFImageView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NFImageView' => ['NFImageView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

s.dependency 'Alamofire', '~> 4.4'
s.dependency 'AlamofireImage', '~> 3.1'

end
