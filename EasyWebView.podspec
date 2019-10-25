Pod::Spec.new do |s|
  s.name                  = 'EasyWebView'
  s.version               = '1.0.0'
  s.summary               = 'use WKWebView easily!'

  s.homepage              = 'https://github.com/alflix/EasyWebView'
  s.license               = { :type => 'Apache-2.0', :file => 'LICENSE' }

  s.author                = { 'John' => 'jieyuanz24@gmail.com' }
  s.social_media_url      = 'https://github.com/Jiar'

  s.platform              = :ios
  s.ios.deployment_target = '8.0'

  s.source                = { :git => 'https://github.com/alflix/EasyWebView.git', :tag => "#{s.version}" }
  s.ios.framework         = 'UIKit'
  s.source_files          = 'Source/*.swift'

  s.module_name           = 'EasyWebView'
  s.requires_arc          = true

  s.swift_version         = '4.2'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.1' }
  s.static_framework      = true
  
end
