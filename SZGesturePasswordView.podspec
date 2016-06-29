
Pod::Spec.new do |s|

  s.name         = "SZGesturePasswordView"

  s.version      = "0.0.1"

  s.summary      = "gesture password view"

  s.homepage     = "https://github.com/chenshengzhi/SZGesturePasswordView"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "陈圣治" => "csz2136@163.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/chenshengzhi/SZGesturePasswordView.git", :tag => s.version.to_s }

  s.source_files = "SZGesturePasswordView/*.{h,m}"

  s.requires_arc = true

end
