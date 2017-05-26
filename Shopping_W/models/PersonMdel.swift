//
//  PersonMdel.swift
//  caizhu
//
//  Created by wanwu on 16/9/8.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class PersonMdel: NSObject, ParseModelProtocol, NSCoding {
    static let man = "M"
    static let woman = "F"
    static let secrite = "S"
    
    var id: Double = 0
    var name: String?
    var gender: String?

    var photo: String?
    var tag: NSDictionary?
    
    class func getGenderStr(gender: String?) -> String {
        switch gender {
        case man?:
            return "男"
            
        case woman?:
            return "女"
            
        default:
            return "保密"
        }
    }
    
    var mobile: String?
    var password: String?
    var userName: String?
    
    var havearticle = "NO"
    
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
    
    override init() {
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
