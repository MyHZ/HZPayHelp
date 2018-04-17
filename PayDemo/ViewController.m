//
//  ViewController.m
//  PayDemo
//
//  Created by 黄震 on 2018/4/9.
//  Copyright © 2018年 CocoaJason. All rights reserved.
//

#import "ViewController.h"
#import "HZPayShareInstance.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 打开支付宝支付

 @param orderString 从服务器获取到的订单信息
 */
-(void)openAliPay:(NSString *)orderString
{
    HZPayShareInstance * payManager = [HZPayShareInstance sharedInstance];
    [payManager openAliPay:orderString AliPayResult:^(BOOL result, NSString *errStr, NSString *resultStr) {
        if (result)
        {
            /*
             成功
             */
        }
        else
        {
            /*
             其他原因
             errStr 为错误的消息
             */
        }
    }];
}

/**
 打开微信支付

 @param wechatDic 从服务器获取到的字典信息
 */
-(void)openWechat:(NSDictionary *)wechatDic
{
    HZPayShareInstance * payManager = [HZPayShareInstance sharedInstance];
    [payManager openWxPay:wechatDic WxPayResult:^(int errCode, NSString *errStr) {
        switch (errCode) {
            case WXSuccess:
            {
                /*
                 成功
                 */
            }
                break;
                
            case WXErrCodeUserCancel:
            {
                /*
                 取消
                 */
            }break;
                
            case WXErrCodeSentFail:
            {
                /*
                 失败
                 */
            }break;
                
            default:
                break;
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
