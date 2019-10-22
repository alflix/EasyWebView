Pod::Spec.new do |s|
  s.name             = 'EasyWebView'
  s.version          = '1.0.0'
  s.summary          = 'use WKWebView easily!'
  s.homepage         = 'https://github.com/alflix/EasyWebView'
  s.license          = { :type => 'MIT', :text => "Copyright 2019" }
  s.author           = { 'John' => 'jieyuanz24@gmail.com' }
  s.source           = { :git => 'https://github.com/tilltue/EasyWebView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.1' }
  s.source_files = 'Source/*.swift'
end
