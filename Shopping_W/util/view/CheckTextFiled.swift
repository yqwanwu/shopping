//
//  AutoUpTextFiled.swift
//  server
//
//  Created by wanwu on 16/7/14.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

class CheckTextFiled: UITextField, AnimationsProtocol, UITextFieldDelegate {
    private var checkError: ((_ textFiled: CheckTextFiled) -> Bool)?
    var canBeEmpty = false
    
    func setCheck(_ check: ((_ textFiled: CheckTextFiled) -> Bool)?) {
        checkError = check
    }
    
    static let screenH: CGFloat = {
        return UIScreen.main.bounds.height
    }()

    @discardableResult
    func check() -> Bool {
        if let check = checkError {
            if !canBeEmpty {
                if !Tools.stringIsNotBlank(text: self.text) {
                    self.shake()
                    return false
                }
            }
            if !check(self) {//不通过
                self.shake()
//                self.beRed()
                return false
            } else {
                self.beNormol()
            }
        }
        return true
    }
    
    override var frame: CGRect {
        didSet {
            self.clearButtonMode = .whileEditing
        }
    }
    
    lazy var borderLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4)
        l.path = path.cgPath
        l.fillColor = UIColor.clear.cgColor
        l.lineWidth = 0.5
        l.strokeColor = UIColor.red.cgColor
        return l
    } ()
    var oldStyle: UITextBorderStyle = .none
    
    func beRed() {
        if self.borderStyle != .none {
            self.oldStyle = self.borderStyle
        }
        
        self.beNormol()
        borderLayer.frame = self.bounds
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500)) {
            
//            self.borderStyle = .none
            
            self.layer.addSublayer(self.borderLayer)
            
            let scale: CGFloat = 1.2
            
            let a = CABasicAnimation(keyPath: "transform")
            var tr = CATransform3DIdentity
            tr = CATransform3DScale(tr, scale, scale, 0)
            a.fromValue = tr
            a.toValue = CATransform3DIdentity
            a.duration = 0.4
            a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.borderLayer.add(a, forKey: nil)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(3000)) {
            self.borderLayer.frame = self.bounds
        }
       
    }
    
    func beNormol() {
        if self.oldStyle != .none {
            self.borderStyle = self.oldStyle
        }
        
        self.layer.borderWidth = 0
        self.borderLayer.removeFromSuperlayer()
    }
    
    override func resignFirstResponder() -> Bool {
        let _ = check()
        return super.resignFirstResponder()
    }

    
}
