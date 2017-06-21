#
# Be sure to run `pod lib lint ORImageGallery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ORImageGallery'
  s.version          = '2.0.0'
  s.summary          = 'ORImageGallery - collection view based image gallery.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Pod for display picture gallery, and show custom top layout, and make rotate."

  s.homepage         = 'https://bitbucket.org/omegarinc/orimagegallery'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeny Ivanov' => 'evgeny.ivanov@omega-r.com' }
  s.source           = { :git => "https://bitbucket.org/omegarinc/orimagegallery.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'ORImageGallery/Classes/**/*'

#  s.resource_bundles = {
#    'ORImageGallery' => ['ORImageGallery/Assets/*.png']
#  }

  s.frameworks = 'UIKit'
  s.dependency 'PureLayout', '~> 3.0.2'
  s.dependency 'SDWebImage', '>= 3.8.2'
end
