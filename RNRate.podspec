require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'RNRate'
  s.version      = package['version']
  s.summary      = package['description']
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.author       = { "author" => package['author']['name'] }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/KjellConnelly/react-native-rate.git", :branch => "master" }
  s.source_files = "ios/*.{h,m,mm}"
  s.requires_arc = true

  s.dependency "React-Core"
  s.framework    = "StoreKit"

  install_modules_dependencies(s)

end
