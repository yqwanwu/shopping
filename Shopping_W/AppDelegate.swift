//
//  AppDelegate.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/16.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NSSetUncaughtExceptionHandler { (ex) in
            print(ex)
        }
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        //realm版本
        let config = Realm.Configuration(
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: 1,
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
        
        //友盟
        let redirectUrl = "https://www.baidu.com"
        UMSocialManager.default().umSocialAppkey = CustomValue.UMAPPKEY
        UMSocialManager.default().setPlaform(.wechatSession, appKey: CustomValue.wxAppId, appSecret: CustomValue.wxAppSecret, redirectURL: redirectUrl)
        UMSocialManager.default().setPlaform(.QQ, appKey: CustomValue.qqAppId, appSecret: CustomValue.qqAppSecret, redirectURL: redirectUrl)
        UMSocialManager.default().setPlaform(.sina, appKey: CustomValue.sinaAppId, appSecret: CustomValue.sinaAppSecret, redirectURL: redirectUrl)
        UMSocialManager.default().removePlatformProvider(withPlatformTypes: [UMSocialPlatformType.qzone.rawValue, UMSocialPlatformType.wechatFavorite.rawValue])
        
        if let _ = UserDefaults.standard.value(forKey: FirstViewController.WELCOME_SHOWED) {
            window?.rootViewController = Tools.getClassFromStorybord(sbName: .main, clazz: CustomTabBarVC.self)
        } else {
            window?.rootViewController = WelcomeVC()
        }
        
        return true
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        AlipaySDK.defaultService().processAuthResult(url) { (dic) in
            if let result = dic?["result"] as? String {
                var authCode: String?
                if Tools.stringIsNotBlank(text: result) {
                    let arr = result.components(separatedBy: "&")
                    for s in arr {
                        if let str = s as? String {
                            if str.characters.count > 10 && str.hasPrefix("auth_code=") {
                                authCode = str.substring(from: str.index(str.startIndex, offsetBy: 10))
                            }
                        }
                    }
                }
                
                print(authCode)
            }
        }
        
        let result = UMSocialManager.default().handleOpen(url)
        if !result {
            //调用其他 SDK
        }
        return result
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result {
            //调用其他 SDK
        }
        return result
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

