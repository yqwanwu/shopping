//
//  FontExtension.swift
//  caizhu
//
//  Created by wanwu on 16/8/22.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

extension UIFont {
    class func customFont(px: CGFloat) -> UIFont {
        let size = px / 2
        
        return UIFont.systemFont(ofSize: size)
    }
}

extension Double {
    func moneyValue() -> String {
        return String(format: "%.2f", self)
    }
}

extension NSObject {
    class func getNameString() -> String {
        let name = NSStringFromClass(self)
        let ps = (name as NSString).pathExtension
        return ps == "" ? name : ps
    }
}

extension URL {
    static func encodeUrl(string: String) -> URL? {
        if let s = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if s.hasPrefix("http") {
                return URL(string: s)
            } else {
                 return URL(string: (NetworkManager.BASESERVER as NSString).appendingPathComponent(s))
            }
           
        }
        return URL(string: string)
    }
}

extension UILabel {
    func addAttrStr(lineSpacing: CGFloat) {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = self.textAlignment
        paraStyle.lineSpacing = lineSpacing
        paraStyle.lineBreakMode = self.lineBreakMode
        let dic = [NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:self.textColor] as [String : Any]
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: dic)
    }
}

extension UIColor {
    public class func hexStringToColor(hexString: String) -> UIColor{
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cString.characters.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#") {cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))}
        if cString.characters.count != 6 {return UIColor.black}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
    
    public static func randColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random() % 100) / 100.0, green: CGFloat(arc4random() % 100) / 100.0, blue: CGFloat(arc4random() % 100) / 100.0, alpha: 1)
    }
}


extension String {
    var MD5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return hash as String
    }
}


