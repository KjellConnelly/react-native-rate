
Pod::Spec.new do |s|
  s.name         = "RNRate"
  s.version      = "1.0.0"
  s.summary      = "RNRate"
  s.description  = <<-DESC
                  RNRate
                   DESC
  s.homepage     = "https://github.com/KjellConnelly/react-native-rate"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNRate.git", :tag => "master" }
  s.source_files  = "RNRate/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  
