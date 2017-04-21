//
//  AppDelegate.m
//  PayPlusSDKDemo
//
//  Created by Sam Pan on 18/04/2017.
//  Copyright © 2017 com.yeepay.payplus. All rights reserved.
//

#import "AppDelegate.h"
#import "QMPaymentViewController.h"
#import "WXApi.h"
#import "PayPlusCore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WXApi registerApp:@"wx95f2b27daf603354"];                      //修改成为您自己在微信平台生成的APPID
    UIScreen *screen  = [UIScreen mainScreen];
    UIWindow *window = [[UIWindow alloc] initWithFrame:screen.bounds];
    QMPaymentViewController *viewController = [[QMPaymentViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor whiteColor]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window = window;
    [self.window makeKeyAndVisible];
    [window setRootViewController:navigationController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 * 【**重要信息**：想得到回调支付后的信息，这两个方法必须实现】
 *  调用第三方处理成功回调【iOS8】
 *
 *  @param application           应用程序对象
 *  @param openURL               地址
 *  @param sourceApplication     源App名称
 *  @param annotation            相关注释信息
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //------------------------------------------
    // 有可能用户使用了第三方的分享SDK，可能会与钱麦SDK冲突
    // 【1】如果这里走的是分享之类的非支付功能，那么使用非支付功能的回调
    //     (使用第三方分享回调或者自己实现回调)
    // 【2】如果这里走的是支付之类的功能，那么使用钱麦的回调方法
    //     [PayPlusCore PayPlusCoreHandleOpenURL:url withCompletion:^(NSString *result, PayPlusError *error){}];
    //------------------------------------------
    
    //防止冲突：微信的非支付功能的url.absuloteString中间字符串是wx**********://pay/格式
    //        微信的支付功能的url.absuloteString中间字符串是wx**********://platformId=wechat/格式
    if ([url.absoluteString rangeOfString:@"wx"].location != NSNotFound &&
        [url.absoluteString rangeOfString:@"://platformId=wechat"].location != NSNotFound ) {
        return [WXApi handleOpenURL:url delegate:(id)self];
    }
    
    //防止冲突：阿里的支付功能的url.absuloteString中间字符串是urlscheme://safepay格式
    if ([url.absoluteString rangeOfString:@"://safepay"].location != NSNotFound ) {
        return [WXApi handleOpenURL:url delegate:(id)self];
    }
    
    NSLog(@"调用第三方处理成功回调【iOS8】");
    NSLog(@"%@",url.absoluteString);
    //此处代码必须实现，如果不实现则无法进行支付回调处理
    return [PayPlusCore PayPlusCoreHandleOpenURL:url withCompletion:^(NSString *result, PayPlusError *error) {
        NSLog(@"iOS8 | result = %@",result);
        NSLog(@"iOS8 | errorCode = %lu",(unsigned long)error.errorChannalCode);
    }];
    
}

/**
 * 【**重要信息**：想得到回调支付后的信息，这两个方法必须实现】
 *  调用第三方处理成功回调【iOS9】
 *
 *  @param application           应用程序对象
 *  @param openURL               地址
 *  @param sourceApplication     源App名称
 *  @param annotation            相关注释信息
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    
    //------------------------------------------
    // 有可能用户使用了第三方的分享SDK，可能会与钱麦SDK冲突
    // 【1】如果这里走的是分享之类的非支付功能，那么使用非支付功能的回调
    //     (使用第三方分享回调或者自己实现回调)
    // 【2】如果这里走的是支付之类的功能，那么使用钱麦的回调方法
    //     [PayPlusCore PayPlusCoreHandleOpenURL:url withCompletion:^(NSString *result, PayPlusError *error){}];
    //------------------------------------------
    
    //防止冲突：微信的非支付功能的url.absuloteString中间字符串是wx**********://pay/格式
    //        微信的支付功能的url.absuloteString中间字符串是wx**********://platformId=wechat/格式
    if ([url.absoluteString rangeOfString:@"wx"].location != NSNotFound &&
        [url.absoluteString rangeOfString:@"://pay/"].location != NSNotFound ) {
        NSLog(@"调用第三方处理成功回调【iOS9】");
        NSLog(@"%@",url.absoluteString);
        return [PayPlusCore PayPlusCoreHandleOpenURL:url withCompletion:^(NSString *result, PayPlusError *error) {
            NSLog(@"iOS9 | result = %@",result);
            NSLog(@"iOS9 |errorCode = %lu",(unsigned long)error.errorChannalCode);          //错误码请前往PayPlusCore.h查找枚举说明
        }];
    }
    
    //防止冲突：阿里的支付功能的url.absuloteString中间字符串是urlscheme://safepay格式
    if ([url.absoluteString rangeOfString:@"://safepay"].location != NSNotFound ) {
        NSLog(@"调用第三方处理成功回调【iOS9】");
        NSLog(@"%@",url.absoluteString);
        //此处代码必须实现，如果不实现则无法进行支付回调处理
        return [PayPlusCore PayPlusCoreHandleOpenURL:url withCompletion:^(NSString *result, PayPlusError *error) {
            NSLog(@"iOS9 | result = %@",result);
            NSLog(@"iOS9 |errorCode = %lu",(unsigned long)error.errorChannalCode);          //错误码请前往PayPlusCore.h查找枚举说明
        }];
    }
    
    return YES;
}

@end
