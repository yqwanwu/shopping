//
//  NormalTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class NormalTableViewCell: CustomTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model {
                if (m.text?.hasSuffix("_b"))! {
                    titleLabel.text = m.text?.substring(to: (m.text?.index((m.text?.endIndex)!, offsetBy: -2))!)
                    titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
                } else {
                    titleLabel.text = m.text
                    titleLabel.font = UIFont.systemFont(ofSize: 15)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
}
