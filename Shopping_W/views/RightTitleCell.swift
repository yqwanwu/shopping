//
//  RightTitleCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/5.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class RightTitleCell: CustomTableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model {
                leftLabel.text = m.text
                rightLabel.text = m.detailText
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
