//
//  CustomButton.swift
//  caizhu
//
//  Created by wanwu on 16/8/30.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var isHighlighted: Bool {
        set {
            
        }
        get {
            return false
        }
    }

}
