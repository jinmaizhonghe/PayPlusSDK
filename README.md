# PayPlusSDK
    PayPlusSDK是由金麦众合提供的聚合支付客户端一站式的集成解决方案，PayPlusSDK大大的降低了开发者对各家SDK集成的难度，大大提升了用户的开发效率，让开发者将自己的精力聚焦在业务开发上面。

## 版本要求
    iOS7&iOS7+
   
## 接入说明(使用 CocoaPods)
    （1）添加SDK引用在podfile中
        pod 'PayPlusSDK', '~> 1.0.0'  //根据需要添加实际版本
    （2）pod install --verbose --no-repo-update
    （3）点击.xcworkspace打开工程，不要打开.xcodeproj  
    
## 常见问题说明：
## <1> 打不开微信App？
    (1)确保自己在didFinishLaunchingWithOptions方法里面有注册微信SDK的代码
       [WXApi registerApp:"Your weixin appid."]; //切记参数AppId是自己在微信支付开放平台获取的
    (2)确保自己的build settings 设置了 -ObjC -all_load 标志位
    (3)确保自己是设置了LSApplicationQueriesSchemes
       <string>weixin</string>
       <string>wechat</string>
## <2> 打不开支付宝App？   
    (1)确保自己的build settings 设置了 -ObjC -all_load 标志位
    (2)确保自己是设置了LSApplicationQueriesSchemes
       <string>alipay</string>
       <string>alipays</string>
## <3> 支付完成后无法跳回微信？
    (1)确保自己工程设置的"info"->"URL Type"包含一项:
       identifier : weixin
       URL Scheme : wxXXXXXXXXXXXXXX（这个必须是你从微信支付开放平台获取的，和 [WXApi registerApp:"Your weixin appid."]里面的参数是一致
       注意: URL Scheme可以设置多个，不需要覆盖您当前的设置。
## <4> iOS 9 限制了 http 协议的访问，如果 App 需要访问 http://，需要在 Info.plist 添加如下代码：
    <key>NSAppTransportSecurity</key>
        <dict>
            <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
## <5> 编译失败问题，报错XXXXXXX does not contain bitcode.？
    请到 Xcode 项目的 Build Settings 标签页搜索 bitcode，将 Enable Bitcode 设置为 NO。
## <6> SDK允许用户进行灵活的配置
    (1)如果您当前只使用了微信支付功能，那么只需要在您的podfile中配置该渠道的
       pod 'PayPlusSDK', '~> 1.0.0'         //根据需要添加实际版本
       pod 'PayPlusSDK/Wxpay’, '~> 1.0.0'   //根据需要添加实际版本
    (2)如果您当前同时使用了微信和支付宝的支付功能，那么需要在您的podfile中同时配置如下
       pod 'PayPlusSDK', '~> 1.0.0'         //根据需要添加实际版本
       pod 'PayPlusSDK/Alipay’, '~> 1.0.0'  //根据需要添加实际版本
       pod 'PayPlusSDK/Wxpay’, '~> 1.0.0'   //根据需要添加实际版本
## <7> 关于支付过程中App非正常退出的回调问题，SDK提供的支持机制是: 
    (1)在您的AppDelegate类的openurl方法中写app非正常退出的回调代码
    (2)在您的业务代码类中写支付正常返回后的回调代码，在demo中有具体说明

