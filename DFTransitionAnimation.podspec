Pod::Spec.new do |s|
s.name         = "DFTransitionAnimation"
s.version      = "0.0.1"
s.summary      = "转场动画的封装集成"
s.homepage     = "https://github.com/ongfei/DFTransitionAnimation"
s.license      = 'MIT'
s.author       = { "ongfei" => "ong_fei@163.com" }
s.source       = { :git => "https://github.com/ongfei/DFTransitionAnimation.git", :tag => s.version.to_s }
s.platform      = :ios, '8.0'
s.source_files = 'DFTransitionAnimation/**/*'
s.requires_arc = true
end
