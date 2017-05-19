//
//  ProgressButton.swift
//  动画测试zz
//
//  Created by wanwu on 17/1/3.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ProgressButton: UIButton {
    enum ProgressButtonLocation: Int {
        case left = 0, right, center
    }
    
    var indicatorMargin: CGFloat = 2.0
    var location: ProgressButtonLocation = .center {
        didSet {
            switch location {
            case .left:
                indicatorView.frame.origin = CGPoint(x: indicatorMargin, y: indicatorMargin)
            case .right:
                indicatorView.frame.origin = CGPoint(x: indicatorMargin, y: indicatorMargin)
            default:
                indicatorView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            }
        }
    }
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let h = min(self.bounds.width, self.bounds.height) - self.indicatorMargin * 2
        let a = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: h, height: h))
        a.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        a.activityIndicatorViewStyle = .gray
        a.color = UIColor.black
        return a
    } ()
    
    func startProgress() {
        indicatorView.startAnimating()
        self.isEnabled = false
    }
    
    func stopProgress() {
        indicatorView.stopAnimating()
        self.isEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(indicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(indicatorView)
    }

    
    
}
 
