//
//  PayPlusCore.h
//  PayPlusCore
//
//  Created by Sam Pan on 14/03/2017.
//  Copyright © 2017 com.yeepay.payplus. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "PayPlusConfig.h"

typedef NS_ENUM(NSUInteger, PayPlusErrorOption){
    PayPlusErrNone = 0,
    PayPlusErrNotInstalled,                         //Level1 未安装
    PayPlusErrVersionNotSupport,                    //Level1 版本不支持
    
    PayPlusErrInvalidCharge,                        //Level2 错误的订单
    PayPlusErrInvalidChannel,                       //Level2 错误的通道
    PayPlusErrViewControllerIsNil,                  //Level2 控制器为空
    
    PayPlusErrCancelled,                            //Level3 用户取消操作
    PayPlusErrCFailure,                             //Level3 支付错误
    PayPlusErrUnknownError,                         //Level3 未知错误
    PayPlusErrProcessing,                           //Level3 正在处理中
};

@interface PayPlusError : NSObject

@property (assign,   nonatomic) NSString           *errorChannalName;
@property (assign,   nonatomic) PayPlusErrorOption errorChannalCode;

@end

@interface PayPlusCore : NSObject

typedef void (^PayPlusCompletion)(NSString *result, PayPlusError *error);


/**
 *  统一支付调用接口
 *
 *  @param charge          服务器返回来的支付凭证(JSON 格式字符串 或 NSDictionary)
 *  @param viewController  当前支付页面控制器
 *  @param scheme          支付完成后返回App需要的Scheme
 *  @param completionBlock 支付完成后的回调
 */
+ (void)PayPlusCoreStartToPayWithCharge:(NSObject *)charge viewController:(UIViewController*)viewController appURLScheme:(NSString *)appURLScheme completionBlock:(PayPlusCompletion)completionBlock;

/**
 *  回调结果接口(支付中途App Crash)
 *
 *  @param url              结果url
 *  @param completionBlock  支付结果回调 Block，保证跳转支付过程中，当 app 被 kill 掉时，能通过这个接口得到支付结果
 *
 *  @return                 当无法处理 URL 或者 URL 格式不正确时，会返回 NO。
 */
+ (BOOL)PayPlusCoreHandleOpenURL:(NSURL *)url withCompletion:(PayPlusCompletion)completion;

/**
 *  版本号
 *
 *  @return         PayPlus SDK 版本号
 */
+ (NSString *)version;

/**
 *  设置 Debug 模式
 *
 *  @param enabled    是否启用
 */
+ (void)setDebugMode:(BOOL)enabled;


@end

