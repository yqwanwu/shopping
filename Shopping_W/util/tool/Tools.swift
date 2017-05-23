//
//  Tools.swift
//  caizhu
//
//  Created by wanwu on 16/8/19.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

/// swift3 升级，代码大量修改，提前准备，到时只需要改这里的代码
class Tools: NSObject {
    enum StoryboardName: String {
        case main = "Main", first = "First", category = "Category", mine = "Mine", shoppingCar = "ShoppingCar"
    }

    class func refreshInMainQueue(_ doSome: (() -> Void)?) {
        if let block = doSome {
            DispatchQueue.main.async {
                block()
                
            }
        }
    }
    
    class func getClassFromStorybord(sbName: StoryboardName, clazz: AnyClass) -> UIViewController {
        let s = UIStoryboard(name: sbName.rawValue, bundle: Bundle.main)
        let str = NSStringFromClass(clazz).components(separatedBy: ".").last
        return s.instantiateViewController(withIdentifier: str!)
    }
    
    private class func findAllSubViews(topView: UIView, arr: inout [UIView]) {
        for view in topView.subviews {
            if view.subviews.count > 0 {
                findAllSubViews(topView: view, arr: &arr)
            }
            arr.append(view)
        }
    }
    
    class func searchStr(str: String, regexStr: String) -> NSRange? {
        do {
            let regex = try NSRegularExpression(pattern: regexStr, options: [.caseInsensitive])
            let matches = regex.matches(in: str, options:  NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: str.characters.count))
            for m in matches {
                return m.range
            }
        } catch {
            return nil
        }
        return nil
    }
    
    class func findAllSubViews(topView: UIView) -> [UIView] {
        var arr = [UIView]()
        findAllSubViews(topView: topView, arr: &arr)
        return arr
    }
    
    class func stringIsNotBlank(text: String?) -> Bool {
        if text == nil {
            return false
        }
        let str = text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if str.characters.count < 1 {
            return false
        }
        return true
    }
    
    ///判断是否是中文
    class func isIncludeChinese(str: String) -> Bool {
        for ch in str.unicodeScalars {
            // 中文字符范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value  && ch.value < 0x9fff) {
                return true
            }
        }
        return false
    }
    
    //转换成拼音
    class func transformToPinyin(str: String) -> String {
        if !isIncludeChinese(str: str) {
            let index = str.index(str.startIndex, offsetBy: 1)
            return str.substring(to: index)
        }
        let stringRef = NSMutableString(string: str) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
        let pinyin = stringRef as String;
        return pinyin
    }
    
    //取拼音的首字母
    class func getPinyinHead(str: String) -> String {
        // 字符串转换为首字母大写
        let pinyin = transformToPinyin(str: str).uppercased()
        var headPinyinStr = ""
        // 获取所有大写字母
        for ch in pinyin.characters {
            if ch <= "Z" && ch >= "A" {
                headPinyinStr.append(ch)
                break
            }
        }
        return headPinyinStr
    }
    
}



