//
//  APPays.m
//  caizhu
//
//  Created by wanwu on 16/9/26.
//  Copyright © 2016年 wanwu. All rights reserved.
//

#import "APPays.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation APPays

+ (void)doAlipayPay
{
    
    
    
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2016082401794476";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANvTMUaI4so+Ctav5BgKjQlw/YpbAZDxry1OiwDkLyVw64zW3sRNFVX4c0NT6rHr/FIOD+bNmrc58Aq6aaCNRI4vV6FV84QndThRMVhFCmU7BCoychIXPwiEU3agEKf7JM7SzAe/sKAnQ9HPsn9d1AEbfbCE0VIHxg6odRIDffz9AgMBAAECgYAoUiumqXMX75tjV6357u2BvtTyrNCzunEMWWzLxA8Vygmassr3rL/uHf1eayUQb52/m061Yh8v3pO2FA1N4ruhFcxewSL5NRGMCdHuRNwvYDWNqRf6MQaFXqi24ZP+Ngwr4U5+Pr9G/4q0MC07QWfztM91xKVhja6n5YUuttOoYQJBAPp6h8kI/90rN7N3DiEmgFHQPH+96aJ5+7mzzJiQs5j9h7pwIj3xXtEogK7WcQI5qd0LFUQ6by8t4sHN5PZdHSUCQQDgq65gu4fCs8cWbzgV6Qr1aDEbjU7U4o7SSdnPumVAbwEgnSg+Wu9UPS7zYjDYCAjQymtKkvag9vKsud5ygtT5AkEAqMfiMZwn1V+m0/6YfcwU0YxRB/7vrPUno3W9mtx+uMu2JvIikLzRmH0DYUzMr6Qtiu5J8USy4Qa5csCL1VrfJQJBAIamnlYfTphkgtdxRN3s08KM9ZGbuTlhp1NlK4OSJQje/n/7cJkeiv2jxbXcjYWMGyx3hKInPmTuXDclFqruupECQQCwTXVlFpReRPuJXfyCIYTUxBneWIgatYbeZBGMF/RWrvain5X1qqQCtEqVCWDo6xIqB4K0MV058+D6IWIMEZ+h";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"caizhu";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


@end
