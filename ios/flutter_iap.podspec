#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_iap'
  s.version          = '1.2.0'
  s.summary          = 'in app purchases for flutter'
  s.description      = <<-DESC
in app purchases for flutter
                       DESC
  s.homepage         = 'https://github.com/JackAppDev/flutter_iap/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jack ODonnell' => 'jackappdevinc@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.swift_version = '4.0'
  
  s.ios.deployment_target = '8.0'
end

