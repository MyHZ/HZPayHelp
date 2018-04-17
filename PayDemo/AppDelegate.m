//
//  AppDelegate.m
//  PayDemo
//
//  Created by 黄震 on 2018/4/9.
//  Copyright © 2018年 CocoaJason. All rights reserved.
//

#import "AppDelegate.h"
#import "HZPayShareInstance.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    return YES;
}

- (void)SetUpWXPayAndAliPay
{
    NSString *wxId = @"";
    [[HZPayShareInstance sharedInstance] registerApp:wxId];
    NSString *ALiPayScheme = @"";
    [[HZPayShareInstance sharedInstance] setUpAlipaySchemeStr:ALiPayScheme];
}

#pragma mark - 处理微信 qq 支付宝返回的请求
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[HZPayShareInstance sharedInstance]PayForResults:url];
    return YES;
}

-(BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString *,id> *)options
{
    [[HZPayShareInstance sharedInstance]PayForResults:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[HZPayShareInstance sharedInstance]PayForResults:url];
    return YES;
}


@end
