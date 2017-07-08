//
//  PersonMdel.swift
//  caizhu
//
//  Created by wanwu on 16/9/8.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class PersonMdel: NSObject, ParseModelProtocol, NSCoding {
    
    var fAccountid = 0
    ///登录名
    var fUsername: String = ""
    var fUserpass = ""
    var fNickname = ""
    ///性别 0女 1男
    var fSex = 1

    var fPhone = ""
    ///类型 0普通用户 1内部用户
    var fType = 0
    
    ///身份证
    var fNumber = ""
    var fName = ""
    var fReferee = -1
    var fHeadImgUrl = ""
    
    class func getGenderStr(gender: Int) -> String {
        switch gender {
        case 1:
            return "男"
            
        case 0:
            return "女"
            
        default:
            return "保密"
        }
    }
    
    var mobile: String?
    var password: String?
    var userName: String?
    
    var havearticle = "NO"
    
    var isAutoLogin = true
    
    var openId: String?
//    var loginType = NewFeatureLoginView.loginType_qq
    
    
    class func readData() -> PersonMdel? {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let filePath = (path as NSString?)?.appendingPathComponent("pm.pf")
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath!) as? PersonMdel
    }
    
    func saveData() {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let filePath = (path as NSString?)?.appendingPathComponent("pm.pf")
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath!)
    }
    
    override required init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.autoDecode(coder: aDecoder)
    }
    
    func encode(with aCoder: NSCoder) {
        autoEncode(coder: aCoder)
    }
    
}
