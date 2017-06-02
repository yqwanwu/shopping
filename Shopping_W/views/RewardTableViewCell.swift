//
//  RewardTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class RewardTableViewCell: CustomTableViewCell {
    @IBOutlet weak var lavelLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel! //积分左边的
    @IBOutlet weak var integrateLabel: UILabel! //积分
    @IBOutlet weak var rewardPersent: UILabel!
    @IBOutlet weak var cangetLabel: UILabel!//可获取奖金

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
