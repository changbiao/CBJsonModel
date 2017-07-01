#
# Be sure to run `pod lib lint CBJsonModel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CBJsonModel'
  s.version          = '1.0.1'
  s.summary          = 'Simple, Faster build some form submit App with catgory, Wrapper UITableView delegate and dataSource with block.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  对 JSONModel 的对象进行类别扩展, 方便'语法糖'式的调用 :)
  添加UITableView的相关刷新及事件在Model的配置回调
  已经添加 JSONModel 的依赖,不需要再用 pod 导入JSONModel 库

                       DESC

  s.homepage         = 'https://github.com/changbiao/CBJsonModel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'changbiao' => '5.5.5.b.i.a.o@163.com' }
  s.source           = { :git => 'https://github.com/changbiao/CBJsonModel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CBJsonModel/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CBJsonModel' => ['CBJsonModel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'JSONModel'
end
