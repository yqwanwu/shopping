//
//  ShadowImageView.swift
//  caizhu
//
//  Created by wanwu on 16/8/24.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    var cornerRadius: CGFloat = 0 {
        didSet {
            setupUI()
        }
    }
    var shadowColor = UIColor.gray.cgColor
    var shadowOffset = CGSize(width: 0, height: 0)
    var childView: UIView? {
        didSet {
            if oldValue != nil {
                oldValue?.removeFromSuperview()
            }
            
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = CustomValue.opcity
        
        if let img = childView {
            if img.frame == CGRect.zero {
                img.frame = self.bounds
            }
            
            self.addSubview(img)
            img.layer.cornerRadius = cornerRadius
            img.layer.masksToBounds = true
        }

    }
    
}
