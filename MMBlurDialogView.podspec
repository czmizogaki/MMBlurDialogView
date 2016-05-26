
Pod::Spec.new do |s|

  s.name         = "MMBlurDialogView"
  s.version      = "1.1.2"
  s.summary      = "https://github.com/Objective-C-MMizogaki/MMBlurDialogView"
  s.homepage     = "https://github.com/MMizogaki"
  s.license      = "MIT"
  s.author       = "MMizogaki"
  s.author       = { "MMizogaki" => "m.mizogaki.github@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = {:git => "https://github.com/Objective-C-MMizogaki/MMBlurDialogView.git",:tag => "#{s.version}"}
  s.source_files = 'Classes/MMBlurDialogView.{h,m}'
  s.frameworks   = 'QuartzCore', 'Accelerate'
  s.requires_arc = true

end
