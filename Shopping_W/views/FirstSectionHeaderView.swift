
//
//  FirstSectionHeaderView.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/12.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SystimeModel:NSObject, ParseModelProtocol {
    override required init() {
        super.init()
    }
    
    var sysTime = ""
    
}

class FirstSectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var timer: Timer!
    
    var model: PromotionModel?
    var clickAction: BLANK_CLOSURE?
    
    static var commonSysTime = 0.0
    
    var sysTime: Double = 0.0 {
        didSet {
            FirstSectionHeaderView.commonSysTime = sysTime
        }
    }
    let format: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    } ()
    
    @IBAction func ac_click(_ sender: Any) {
        clickAction?()
    }
    
    func requstServerTime() {
        NetworkManager.requestTModel(params: ["method":"apisystime"]).setSuccessAction { (bm: BaseModel<SystimeModel>) in
            if bm.isSuccess {
                let timeStr = bm.t!.sysTime
                let date = self.format.date(from: timeStr) ?? Date(timeIntervalSinceNow: 0)
                let currentDate = Date(timeIntervalSinceNow: 0)
                //5秒之内的误差，忽略不计
                if abs(currentDate.timeIntervalSince1970 - date.timeIntervalSince1970) > 5 {
                    self.sysTime = date.timeIntervalSince1970
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let arr = [hourLabel, minuteLabel, secondLabel]
        
        for l in arr {
            l?.layer.cornerRadius = 4
            l?.clipsToBounds = true
        }
        
        var i = 0
        timer = Timer.scheduledTimer(1, action: { [unowned self] (t) in
            if i % 300 == 0 {
                self.requstServerTime()
            }
            
            if self.sysTime == 0 {
                self.sysTime = Date(timeIntervalSinceNow: 0).timeIntervalSince1970
            }
            let validDate =  Date(timeIntervalSince1970: self.sysTime)

            self.sysTime += 1
            
            if let m = self.model {
                //测试时间用
//                m.fStarttime = "2017-08-1 12:12:12"
                
                let d = self.format.date(from: m.fStarttime) ?? Date(timeIntervalSinceNow: 0)
                let startTime = d.timeIntervalSince1970
                let currentTime = validDate.timeIntervalSince1970
                
                let sub = Int(startTime - currentTime)
                if sub > 0 {
                    self.hourLabel.text = "\(sub / 3600)"
                    self.minuteLabel.text = "\((sub % 3600) / 60)"
                    self.secondLabel.text = "\((sub % 60))"
                }
            }
            
            i += 1
        }, userInfo: nil, repeats: true)
    }
    
    deinit {
        self.timer.invalidate()
    }
    
}
