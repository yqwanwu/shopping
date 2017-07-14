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
    static let btnCornerRadius: CGFloat = 6
    static let lineSpace: CGFloat = 15
    
    static let common_red = UIColor.hexStringToColor(hexString: "f04649")
    
    static let widthRatio: CGFloat = {
        return UIScreen.main.bounds.width / CustomValue.referenceScreenW
    }()
    
    
    static let htmlHeader = "<html lang='en'>" +
                                "<head>" +
                                "<meta charset='UTF-8'>" +
                                "</head>" +
                                "<body>"
    static let htmlFooter = "</body></html>"
    
    
    
    //友盟
    //58228ae53eae251ae0002164
    static let UMACountPPKEY = "58228ae53eae251ae0002164"
    static let UMAPPKEY = "58228ae53eae251ae0002164"
    static let placehoderImg = UIImage(named: "placehoder")
    
    
    static let wxAppId = "wxdc1e388c3822c80b"
    static let wxAppSecret = "3baf1193c85774b3fd9d18447d76cab0"
    static let qqAppId = "100424468"//41dacaaf
    static let qqAppSecret = "c7394704798a158208a74ab60104f0ba"
    static let sinaAppId = "3921700954"
    static let sinaAppSecret = "04b48b094faeb16683c32669824ebdad"
        
    static func validatePhone(phone: String?) -> Bool {
        if Tools.stringIsNotBlank(text: phone) {
            return phone!.hasPrefix("1") && phone!.characters.count == 11
        }
        return false
    }
    
    static let opcity: Float = 0.3
 
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
    
    static var isWXInsted: Bool {
        set {
            
        }
        
        get {
            return UIApplication.shared.canOpenURL(URL(string: "wechat://")!)
        }
    }
    
    static var isSinaInsted: Bool {
        set {
            
        }
        
        get {
            return UIApplication.shared.canOpenURL(URL(string: "sinaweibosso://")!)
        }
    }
    
    static var isTBInsted: Bool {
        set {
            
        }
        
        get {
            return UIApplication.shared.canOpenURL(URL(string: "taobao://")!)
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

