//
//  HZPayShareInstance.m
//  PayDemo
//
//  Created by 黄震 on 2018/4/9.
//  Copyright © 2018年 CocoaJason. All rights reserved.
//

#import "HZPayShareInstance.h"

@interface HZPayShareInstance()
<WXApiDelegate>

@property(nonatomic,copy) AliPayResult AliPayResult;
@property(nonatomic,copy) WxPayResult WxPayResult;
@property(nonatomic,copy) NSString *AlipaySchemeStr;

@end

@implementation HZPayShareInstance

+ (instancetype)sharedInstance
{
    static HZPayShareInstance* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HZPayShareInstance new];
    });
    
    return instance;
}

+(BOOL) registerApp:(NSString *)appid;
{
    return [WXApi registerApp:appid];
}

- (void) setUpAlipaySchemeStr:(NSString *)schemeStr;
{
    self.AlipaySchemeStr = schemeStr;
}

-(void)PayForResults:(NSURL *)url;
{
    if ([url.host isEqualToString:@"safepay"]) //支付宝客户端支付
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝客户端支付 result = %@",resultDic);
            [self handleAliPayResulr:resultDic];
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]) //支付宝钱包快登授权返回 authCode
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝钱包快登授权返回 authCode result = %@",resultDic);
            [self handleAliPayResulr:resultDic];
        }];
    }
    
    if ([url.host isEqualToString:@"pay"]) //微信支付
    {
        [WXApi handleOpenURL:url delegate:[HZPayShareInstance sharedInstance]];
    }
    
}

-(void)openAliPay:(NSString *)orderString AliPayResult:(AliPayResult)AliPayResult;
{
    [HZPayShareInstance sharedInstance].AliPayResult = AliPayResult;
    NSString *appScheme = @"YourAppScheme";
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"ALiPay reslut = %@",resultDic);
        [self handleAliPayResulr:resultDic];
    }];
}

-(void)handleAliPayResulr:(NSDictionary *)resultDic
{
    NSString * resultStr = resultDic[@"result"];
    NSString * memo = resultDic[@"memo"];
    NSInteger resultValue = [resultDic[@"resultStatus"] integerValue];
    switch (resultValue)
    {
        case 6001:
            memo = @"用户取消支付";
            break;
            
        case 8000:
            memo = @"正在处理中，等待商家确认";
            break;
            
        case 4000:
            memo = @"订单支付失败";
            break;
            
        case 6002:
            memo = @"网络连接出错";
            break;
            
        default:
            memo = @"支付失败";
            break;
    }
    BOOL resultStatus = resultValue == 9000;
    if (self.AliPayResult)
    {
        self.AliPayResult(resultStatus,memo,resultStr);
    }
}

#pragma mark - WeChatPay
-(void)openWxPay:(NSDictionary *)orderDic WxPayResult:(WxPayResult)WxPayResult
{
    [HZPayShareInstance sharedInstance].WxPayResult = WxPayResult;
    NSMutableString * timestamp = orderDic[@"timestamp"];
    //调起微信支付
    PayReq* req             = [PayReq new];
    req.partnerId           =  [orderDic objectForKey:@"partnerid"];
    req.prepayId            = [orderDic objectForKey:@"prepayid"];
    req.nonceStr            = [orderDic objectForKey:@"noncestr"];
    req.timeStamp           = timestamp.intValue;
    req.package             = [orderDic objectForKey:@"package"];
    req.sign                = [orderDic objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        PayResp * payResp = (PayResp *)resp;
        NSLog(@"支付结果－errStr = %@，retcode = %d %@", resp.errStr,resp.errCode,payResp.returnKey);
        if (self.WxPayResult)
        {
            self.WxPayResult(resp.errCode,resp.errStr);
        }
    }
}

@end
