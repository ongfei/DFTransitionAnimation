Pod::Spec.new do |s|
  s.name             = "ongfei"    
  s.version          = "0.0.1"            
  s.summary          = "转场动画的封装集成"     
  ##s.description      = <<-DESC
                       Testing Private Podspec.

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage          = "https://github.com/ongfei/DFTransitionAnimation"  
  s.license          = 'MIT'   #开源协议
  s.author           = { "ongfei" => "ong_fei@163.com" }  #作者信息
  s.source           = { :git => "https://github.com/ongfei/DFTransitionAnimation.git", :tag => s.version.to_s }     

  s.platform     = :ios, '8.0'            
  s.requires_arc = true                   

  s.source_files = 'DFTransitionAnimation/*.{h,m}'
  s.frameworks = 'UIKit'          
end