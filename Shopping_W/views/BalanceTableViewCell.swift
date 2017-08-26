//
//  BalanceTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/1.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class BalanceTableViewCell: CustomTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? MyIntegralModel {
                //0购买奖励 1消费积分
                self.titleLabel.text = m.fType == 0 ? "购买奖励" : "消费积分"
                self.timeLabel.text = m.fCreatetime
                self.moneyLabel.text = "\(m.fIntegral)"
            } else if let m = model as? MyBalanceModel {
//                self.titleLabel.text = m.fState == 0 ? "购买奖励" : "消费积分"
                self.titleLabel.text = ""
                self.timeLabel.text = m.fCreatetime
                self.moneyLabel.text = "\(m.fAmount)"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
