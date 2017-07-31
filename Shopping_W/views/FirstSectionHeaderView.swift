//
//  FirstSectionHeaderView.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/12.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class FirstSectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    var timer: Timer!

    override func awakeFromNib() {
        super.awakeFromNib()
        let arr = [hourLabel, minuteLabel, secondLabel]
        
        for l in arr {
            l?.layer.cornerRadius = 4
            l?.clipsToBounds = true
        }
        
        timer = Timer.scheduledTimer(1, action: { (t) in
            
        }, userInfo: nil, repeats: true)
    }
    
    deinit {
        self.timer.invalidate()
    }
    
}
