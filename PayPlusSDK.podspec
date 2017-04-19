Pod::Spec.new do |s|
  s.name         = 'PayPlusSDK'
  s.version      = '1.0.1'
  s.summary      = 'PayPlusSDK'
  s.description  = <<-DESC
                              PayPlusSDK是由金麦众合提供的聚合支付客户端一站式的集成解决方案，
                              PayPlusSDK大大的降低了开发者对各家SDK集成的难度，大大提升了用户
                              的开发效率，让开发者将自己的精力聚焦在业务开发上面。
                               
  s.homepage     = 'https://github.com/jinmaizhonghe/PayPlusSDK'
  s.license      = 'MIT'
  s.author       = { "Sam" => "security@jia007.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/jinmaizhonghe/PayPlusSDK.git", :tag => s.version }
  s.source_files  = "PayPlusSDK"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
    core.source_files = 'PayPlusSDK/*.h'
    core.public_header_files = 'PayPlusSDK/*.h'
    core.vendored_libraries = 'PayPlusSDK/*.a'
    core.frameworks = 'CFNetwork', 'SystemConfiguration', 'Security'
    core.ios.library = 'c++', 'stdc++', 'z', 'sqlite3.0'
    core.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  end
  
  s.subspec 'Alipay' do|ss|
    ss.ios.vendored_frameworks = 'PayPlusSDK/Channels/Alipay/AlipaySDK.framework'
    ss.resource = 'PayPlusSDK/Channels/Alipay/AlipaySDK.bundle'
    ss.frameworks = 'CoreMotion', 'CoreTelephony'
    ss.vendored_libraries = 'PayPlusSDK/Channels/Alipay/*.a'
    ss.dependency 'PayPlusSDK/Core'
  end
  
  s.subspec 'Wxpay' do|ss|
    ss.vendored_libraries = 'PayPlusSDK/Channels/Wxpay/*.a'
    ss.dependency 'PayPlusSDK/Core'
    ss.frameworks = 'CoreTelephony'
  end
  
end
