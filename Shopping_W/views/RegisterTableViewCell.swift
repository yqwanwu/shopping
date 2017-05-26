//
//  RegisterTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class RegisterTableViewCell: CustomTableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model {
                textField.placeholder = m.detailText
                nameLabel.text = m.text
                if m.text == "密码" {
                    textField.isSecureTextEntry = true
                } else if m.text == "手机号" {
                    textField.keyboardType = .numberPad
                } else {
                    textField.isSecureTextEntry = false
                    textField.keyboardType = .default
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

 

}
