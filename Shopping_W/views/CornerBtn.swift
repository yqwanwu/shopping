//
//  CornerBtn.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/27.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CornerBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = CustomValue.btnCornerRadius
    }
}
