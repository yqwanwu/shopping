//
//  DotRefresh.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/1.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class DotRefresh: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let baseLayer = CAShapeLayer()
        baseLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        baseLayer.cornerRadius = baseLayer.frame.width / 2
        baseLayer.backgroundColor = CustomValue.common_red.cgColor
        
        let rl = CAReplicatorLayer()
        rl.frame = self.bounds
        rl.instanceCount = 3
        rl.instanceDelay = 0.8 / 3
        rl.instanceTransform = CATransform3DMakeTranslation(15, 0, 0)
        rl.addSublayer(baseLayer)
        self.layer.addSublayer(rl)
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = 0.8
        animation.repeatCount = Float.infinity
        animation.toValue = CATransform3DMakeScale(0.5, 0.5, 1)
        baseLayer.add(animation, forKey: nil)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
