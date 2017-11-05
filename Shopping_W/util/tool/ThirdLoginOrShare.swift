//
//  ThirdLoginOrShare.swift
//  caizhu
//
//  Created by wanwu on 16/9/6.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class ThirdLoginOrShare: UIView {

    class func show(viewController: UIViewController, title: String, text: String, img: Any?, url: String) {
//        if configShare().count >= 5 {
//            return
//        }
        
//        UMSocialData.default().extConfig.title = title
//        UMSocialWechatHandler.setWXAppId(CustomValue.wxAppId, appSecret: CustomValue.wxAppSecret, url: url)
//        UMSocialQQHandler.setQQWithAppId(CustomValue.qqAppId, appKey: CustomValue.qqAppSecret, url: url)
//        UMSocialQQHandler.setSupportWebView(true)
//        UMSocialData.default().urlResource.setResourceType(UMSocialUrlResourceTypeWeb, url: url)
//        UMSocialData.default().extConfig.qqData.url = url
//        UMSocialData.default().extConfig.wechatSessionData.url = url
//        UMSocialData.default().extConfig.wechatTimelineData.url = url
//        UMSocialData.default().extConfig.sinaData.urlResource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeWeb, url: url)
//        
//        
//        
//        UMSocialSnsService.presentSnsIconSheetView(viewController, appKey: CustomValue.UMAPPKEY, shareText: text, shareImage: img, shareToSnsNames: [UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToQQ], delegate: nil)
        
        let thumbImage = #imageLiteral(resourceName: "placehoder")
        
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) in
            let messageObject = UMSocialMessageObject()
            
            var str = text
            var tstr = title
            
            if !Tools.stringIsNotBlank(text: text) {
                str = title
            }
            if !Tools.stringIsNotBlank(text: title) {
                tstr = text
            }
            
            if platformType == .sina {
                str = url + str
                messageObject.text = url + title
                
                let so = UMShareImageObject()
                if let iu = img {
                    so.thumbImage = iu
                    so.shareImage = iu
                } else {
                    so.thumbImage = thumbImage
//                    so.shareImage = "http://kofuf.kofuf.com:8080/privilege/uploadedFile/share.png"
                }
                
                messageObject.shareObject = so
            } else {
                var shareObject: UMShareWebpageObject!
                if let iu = img {
                    shareObject = UMShareWebpageObject.shareObject(withTitle: tstr, descr: str, thumImage: iu)
                } else {
                    shareObject = UMShareWebpageObject.shareObject(withTitle: tstr, descr: str, thumImage: "")
                }
                
                shareObject?.webpageUrl = url
                messageObject.shareObject = shareObject
            }
            
//            UMSocialSinaHandler.defaultManager().a
            
            //调用分享接口
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: viewController, completion: { (data, err) in
                if err != nil {
                    
                }
            })
        }
    }
    
    override func layoutSubviews() {
        
    }
    
//    private class func configShare() -> [String] {
//        var hideArr = [String]()
//        if !CustomValue.isQQInsted {
//            hideArr.append(UMShareToQQ)
//            hideArr.append(UMShareToQzone)
//        }
//        
//        if !CustomValue.isWeixinInsted {
//            hideArr.append(UMShareToWechatSession)
//            hideArr.append(UMShareToWechatTimeline)
//        }
//        
//        if !CustomValue.isSinaInsted {
//            hideArr.append(UMShareToSina)
//        }
//        UMSocialConfig.hiddenNotInstallPlatforms(hideArr)
//        return hideArr
//    }
    
}
