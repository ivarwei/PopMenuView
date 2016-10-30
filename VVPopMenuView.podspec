Pod::Spec.new do |s|
  s.name             = "VVPopMenuView"
  s.version          = "0.2.0"
  s.summary          = "VVPopMenuView is pop animation menu inspired by Sina weibo App."
  s.homepage         = "https://github.com/Jasonvvei/VVPopMenuView"
  s.license          = 'MIT'
  s.author           = { "Jasonvvei" => "https://github.com/Jasonvvei" }
  s.platform         = :ios, '8.0'
  s.source           = { :git => "https://github.com/Jasonvvei/PopMenuView.git", :tag => s.version }

  s.source_files     = 'VVPopMenuView/*.{h,m}'
  s.requires_arc     = true
  s.dependency 'pop', 'SDWebImage'

end
