Pod::Spec.new do |s|
  s.name                  = 'EasyWebView'
  s.version               = '1.0.1'
  s.summary               = 'use WKWebView easily!'

  s.homepage              = 'https://github.com/alflix/EasyWebView'
  s.license               = { :type => 'Apache-2.0', :file => 'LICENSE' }

  s.author                = { 'John' => 'jieyuanz24@gmail.com' }
  s.social_media_url      = 'https://github.com/alflix'

  s.swift_version         = "5.1"
  s.ios.deployment_target = "9.0"
  s.platform              = :ios, '9.0'

  s.source                = { :git => 'https://github.com/alflix/EasyWebView.git', :tag => "#{s.version}" }
  s.ios.framework         = 'UIKit'
  s.source_files          = 'Source/*.swift'

  s.module_name           = 'EasyWebView'
  s.requires_arc          = true
  s.static_framework      = true
  
end
