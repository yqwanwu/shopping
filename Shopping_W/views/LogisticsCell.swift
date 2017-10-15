//
//  LogisticsCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class LogisticsCell: CustomTableViewCell {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    var originalColor: UIColor?
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? LogisticsModel {
                timeLabel.text = m.AcceptTime
                detailLabel.text = m.AcceptStation
                if m.isLast {
                    self.timeLabel.textColor = CustomValue.common_red
                    detailLabel.textColor = CustomValue.common_red
                    topLine.backgroundColor = CustomValue.common_red
                    circleView.backgroundColor = CustomValue.common_red
                    topLine.isHidden = true
                } else {
                    self.timeLabel.textColor = UIColor.hexStringToColor(hexString: "888888")
                    detailLabel.textColor = UIColor.hexStringToColor(hexString: "888888")
                    topLine.backgroundColor = originalColor
                    circleView.backgroundColor = originalColor
                    bottomLine.backgroundColor = originalColor
                    topLine.isHidden = false
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleView.layer.cornerRadius = 10
        
        originalColor = topLine.backgroundColor
    }
    
}
