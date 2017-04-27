Pod::Spec.new do |s|
  s.name         = "XLPopGesture"
  s.version      = "1.5"
  s.summary      = "A custom PopGesture with AOP."
  s.description  = "A custom PopGesture with AOP. Just pod in 2 files and no need for any setups."
  s.homepage     = "https://github.com/cctomato/XLPopGesture"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "cctomato" => "cyq_1103@live.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/cctomato/XLPopGesture.git", :tag => "#{s.version}" }

  s.source_files  = "XLPopGesture/*.{h,m}"

  s.requires_arc = true

end
