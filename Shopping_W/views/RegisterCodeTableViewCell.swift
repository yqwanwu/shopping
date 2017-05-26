//
//  RegisterCodeTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class RegisterCodeTableViewCell: CustomTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeBtn: CountdownButton!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model {
                nameLabel.text = m.text
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        codeBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        codeBtn.layer.borderWidth = 1
        codeBtn.layer.borderColor = CustomValue.common_red.cgColor
    }

    @IBAction func ac_getCode(_ sender: UIButton) {
        print("asdasfas")
        sender.isSelected = true
    }
}
