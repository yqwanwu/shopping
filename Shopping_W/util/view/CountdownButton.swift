//
//  CountdownButton.swift
//  caizhu
//
//  Created by wanwu on 16/8/19.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class CountdownButton: UIButton {
    var counnt = 60
    var timer: Timer!
    
    override var isHighlighted: Bool {
        set {
            
        }
        get {
            return false
        }
    }
    
    func recover() {
        self.isSelected = false
        self.timer.invalidate()
        counnt = 60
    }

    var ox: CGFloat = -1000
    override var isSelected: Bool {
        didSet {
            if ox == -1000 {
                ox = self.frame.origin.x
            }
            if !oldValue && isSelected {
                unowned let weakSelf = self
                weakSelf.counnt = 60
                self.frame.size.width = 132
                self.frame.origin.x = ox - 32
                weakSelf.setTitle("\(weakSelf.counnt)秒后重新获取", for: .selected)
                timer = Timer.scheduledTimer(1, action: { (sender) in
                    Tools.refreshInMainQueue({
                        weakSelf.setTitle("\(weakSelf.counnt)秒后重新获取", for: .selected)
                        weakSelf.counnt -= 1
                        if weakSelf.counnt <= 0 {
                            weakSelf.isSelected = false
                            
                            if let c = weakSelf.complete {
                                c()
                            }
                            weakSelf.timer.invalidate()
                        }
                    })
                    }, userInfo: nil, repeats: true)
            } else {
                self.frame.size.width = 100
                self.frame.origin.x = ox
            }
        }
    }
    
    var complete: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        
    }
    
    deinit {
        if timer != nil {
            timer.invalidate()
        }
    }

}
