#
# Be sure to run `pod lib lint CocoapodsFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CocoapodsFramework'
  s.version          = '0.1.0'
  s.summary          = 'A short description of CocoapodsFramework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wangzhen/CocoapodsFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangzhen' => 'wangzhen-tc@dfmc.com.cn' }
  s.source           = { :git => 'https://github.com/wangzhen/CocoapodsFramework.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CocoapodsFramework/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CocoapodsFramework' => ['CocoapodsFramework/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错 image not found
#    s.static_framework  =  true
    
    # 需要对外开放的头文件   打包只公开特定的头文件
#    s.public_header_files = 'CocoapodsFramework/Classes/CocoapodsFramework.h'
    # 调试公开所有的头文件 这个地方下面的头文件 如果是在Example中调试 就公开全部，需要打包就只公开特定的h文件
    # s.public_header_files = 'VideoPlayerLib/Classes/**/*.h'

    # 链接设置 重要
     # s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
  
   s.dependency 'AFNetworking'
end
