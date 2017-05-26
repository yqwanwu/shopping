//
//  MineButton.swift
//  caizhu
//
//  Created by wanwu on 16/8/29.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class MineButton: UIButton {
    
    var imgRatio: CGFloat = 1.0
    var badgeValue: String? {
        didSet {
            badgeView.badgeValue = self.badgeValue
//            let w = frame.width * imgRatio
            badgeView.frame.origin.x = frame.width / 2 + 2
//            badgeView.center.y = -1
            titleLabel?.textAlignment = .center
        }
    }
    
    class func parseNumer(num: Int) -> String? {
        if num < 1 {
            return nil
        }
        
        if num > 99 {
            return "99+"
        }
        return String(num)
    }
    
    private var badgeView: BadgeView = BadgeView.create()

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let w = frame.width * imgRatio
        
        return CGRect(x: (frame.width - w) / 2, y: 0, width: w, height: w)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: frame.height - 15, width: contentRect.width, height: 15)
    }
    
    override func draw(_ rect: CGRect) {
        addSubview(badgeView)
        self.titleLabel?.textAlignment = .center
//        badgeView.badgeValue = "1"
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
