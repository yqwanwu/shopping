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

    class func refreshInMainQueue(_ doSome: (() -> Void)?) {
        if let block = doSome {
            DispatchQueue.main.async {
                block()
                
            }
        }
    }
    
    class func getClassFromStorybord(clazz: AnyClass) -> UIViewController {
        let s = UIStoryboard(name: "Main", bundle: Bundle.main)
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
    
}



