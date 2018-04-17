# HZPayHelp
简单封装微信与支付宝支付代码，帮助大家快速完成iOS端支付的进入
本工程仅对第三方SDK代码进行整合，并未添加其他代码，请放心使用。
如果您对本代码有建议或者意见，也请您留言。

1.支付SDK的配置

支付宝支付
```
   NSString *ALiPayScheme = @"";
    [[HZPayShareInstance sharedInstance] setUpAlipaySchemeStr:ALiPayScheme];
```
微信支付
```
    NSString *wxId = @"";
    [[HZPayShareInstance sharedInstance] registerApp:wxId];
```
2.打开支付APP进行支付
本工程是对返回的结果进行列举，您需要自己对您自己的业务进行处理
您也可根据自身需求进行修改

支付宝支付
```
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
```

微信支付
```
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
```

3.处理支付结果

APPdelegate中，对支付APP返回的URL进行解析

```
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
```

