//
//  AnimationsProtocol.swift
//  server
//
//  Created by wanwu on 16/7/21.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

protocol AnimationsProtocol {
    ///左右晃动
    func shake()

    func transitionAnimate(type: String)
}

///默认实现
extension AnimationsProtocol where Self: UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [10, -10, 9, -9, 8, -8, 6, -6, 5, -5, 2, -2, 1, -1].map({ (x) -> Int in
            Int(self.center.x) + x
        })
        animation.repeatCount = 1
        animation.duration = 0.4
        self.layer.add(animation, forKey: "")
    }
    
    
    func transitionAnimate(type: String = kCATransitionFade) {
        let t = CATransition()
        t.duration = 0.35
        t.type = type
        self.layer.add(t, forKey: nil)
    }
    
}













