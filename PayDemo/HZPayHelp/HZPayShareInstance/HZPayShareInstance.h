//
//  HZPayShareInstance.h
//  PayDemo
//
//  Created by 黄震 on 2018/4/9.
//  Copyright © 2018年 CocoaJason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APOpenAPI.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

typedef void (^WxPayResult)(int errCode,NSString *errStr);
typedef void (^AliPayResult)(BOOL result,NSString * errStr,NSString * resultStr);

@interface HZPayShareInstance : NSObject

+ (instancetype)sharedInstance;

/*
 处理支付完成（成功或者失败）
 */
- (void)PayForResults:(NSURL *)url;

#pragma mark - 支付宝支付
/*
 支付宝scheme
 */
- (void) setUpAlipaySchemeStr:(NSString *)schemeStr;
/**
 打开支付宝支付
 */
-(void) openAliPay:(NSString *)orderString
      AliPayResult:(AliPayResult)AliPayResult;

#pragma mark - 微信支付
/*
 注册微信APPID
 */
- (BOOL) registerApp:(NSString *)appid;
/**
 打开微信支付
 */
- (void) openWxPay:(NSDictionary *)orderDic
     WxPayResult:(WxPayResult)WxPayResult;

@end
