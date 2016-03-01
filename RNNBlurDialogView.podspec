
Pod::Spec.new do |s|

  s.name         = "BlurDialogView"
  s.version      = "1.0.0"
  s.summary      = "https://github.com/MMizogaki/BlurDialogView"
  s.homepage     = "https://github.com/MMizogaki"
  s.license      = "MIT"
  s.author       = "MMizogaki"
  s.author       = { "MMizogaki" => "m.mizogaki.github@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = {:git => "https://github.com/MMizogaki/BlurDialogView.git",:tag => "#{s.version}"}
  s.source_files = 'Classes/RNNBlurDialogView.{h,m}'
  s.frameworks   = 'QuartzCore', 'Accelerate'
  s.requires_arc = true

end
