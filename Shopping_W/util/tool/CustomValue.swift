//
//  CustomValue.swift
//  caizhu
//
//  Created by wanwu on 16/9/7.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

struct CustomValue {
    //参考宽度
    static let referenceScreenW: CGFloat = 375.0
    static let widthRatio: CGFloat = {
        return UIScreen.main.bounds.width / CustomValue.referenceScreenW
    }()
    //友盟
    //58228ae53eae251ae0002164
    static let UMACountPPKEY = "58228ae53eae251ae0002164"
    static let UMAPPKEY = "58228ae53eae251ae0002164"
    static let placehoderImg = UIImage(named: "placehoder")
    
    
    static let wxAppId = "wx2b2533783589cf47"
    static let wxAppSecret = "cf1d5b9bfdfcbdb4ca9d6804559cb42c"
    static let qqAppId = "1104857775"//41dacaaf
    static let qqAppSecret = "c7394704798a158208a74ab60104f0ba"
    static let sinaAppId = "305666980"
    static let sinaAppSecret = "c7decb6906b0fd9f7cc75cb2f7506223"
    
    static let iconimg = UIImage(named: "AppIcon.png")
    
    static func validatePhone(phone: String?) -> Bool {
        if Tools.stringIsNotBlank(text: phone) {
            return phone!.hasPrefix("1") && phone!.characters.count == 11
        }
        return false
    }
    
    static let opcity: Float = 0.3
    
    static let host = "http://121.40.216.238/PsychologicalEvaluationSys/"//"http://192.168.1.3:8080/PsychologicalEvaluationSys/"//
    static let pageSize = 10
        
    static func dealNumber(num: Int) -> String {
        var str = num.description
        if num >= 10000 {
            str = String(format: "%.2f万", arguments: [Float(num) / 10000.0])
        }
        return str
    }
    
    static func bundleVersion() -> String {
        let info = Bundle.main.infoDictionary
        return info?["CFBundleVersion"] as? String ?? ""
    }
    
    ///f: 小数， i:整数
    static func getNumber(obj: Any, type: String, defaultValue: Double = 0.0) -> NSNumber {
        if let obj = obj as? NSNumber {
            return obj
        } else if let s = obj as? NSString {
            if type == "f" {
                let v = s.doubleValue
                return NSNumber(value: v)
            } else {
                let v = s.longLongValue
                return NSNumber(value: v)
            }

        }
        return NSNumber(value: defaultValue)
    }
    
    static var isQQInsted: Bool {
        set {
            
        }
        
        get {
            return UIApplication.shared.canOpenURL(URL(string: "mqq://")!)
        }
    }
    
    static var isSinaInsted: Bool {
        set {
            
        }
        
        get {
            return UIApplication.shared.canOpenURL(URL(string: "sinaweibosso://")!)
        }
    }
    
    static func getDateComponents(date : Date) -> DateComponents {
        let c = Calendar(identifier: Calendar.Identifier.gregorian)
        let unitFlag = Set<Calendar.Component>([.hour, .minute, .second, .year, .weekday, .month, .day])
        return c.dateComponents(unitFlag, from: date)
    }
    
    static var ssszDateFormat: DateFormatter {
        get {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return df
        }
        
    }
    
    static func perStr(count: Int, unit: String) -> String {
        var str = count > 1 ? count.description : ""
        switch unit.uppercased() {
        case "Y":
            if count == 6 {
                str = "半年"
            } else {
                str = str + "年"
            }
            
        case "M":
            str = str + "月"
            
        case "D":
            str = str + "天"
            
        default:
            return ""
        }
        return "/" + str
    }
    
    static func byteToString(byte: [UInt8]) -> String {
        let output = NSMutableString(capacity: byte.count)
        for byte in byte {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}

