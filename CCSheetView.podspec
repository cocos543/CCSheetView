#
# Be sure to run `pod lib lint CCSheetView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CCSheetView'
  s.version          = '0.1.0'
  s.summary          = 'CCSheetView继承自UITableView, 它实现了Cell的横向滚动功能, 并且支持多个Cell横向同步滚动, 效果看起来就像Office Excel, 能展示出行列视图.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CCSheetView继承自UITableView, 它实现了Cell的横向滚动功能, 并且支持多个Cell横向同步滚动, 效果看起来就像Office Excel, 能展示出行列视图.
通过继承内部的Component, 来定制自己的Cell界面.
其中Component内部已经集成了一个UICollectionView, 并提供了UIScrollView和UICollectionView两个属性(指向同一个CollectionView), 用户可以向UICollectionView注册新的ColumnCell来定制列UI, 这样的好处是横向滚动也支持复用, 也可以简单使用UIScrollView作为横向滚动的承载视图. 或者完成重写Component的布局, 自己设计Cell.

需要注意的是, Cell和Header子类必须要继承自Component, 提供UIScrollView或者子类, 这个是支持横向滚动的关键. 具体定制方法可以继续往下看`教程`部分.
                       DESC

  s.homepage         = 'https://github.com/cocos543/CCSheetView'
  s.screenshots     = 'https://raw.githubusercontent.com/cocos543/CCSheetView/dev/demo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cocos543' => '543314602@qq.com' }
  s.source           = { :git => 'https://github.com/cocos543/CCSheetView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CCSheetView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CCSheetView' => ['CCSheetView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry', '~> 1.1.0'
end
