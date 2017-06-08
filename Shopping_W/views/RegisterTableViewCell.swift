//
//  RegisterTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class RegisterTableViewCell: CustomTableViewCell {

    @IBOutlet weak var textField: CheckTextFiled!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model {
                textField.placeholder = m.detailText
                nameLabel.text = m.text
                if m.text?.contains("密码") ?? false {
                    textField.isSecureTextEntry = true
                    textField.setCheck { (tf) -> Bool in
                        let c = (tf.text ?? "").characters.count
                        return c < 15 && c > 5
                    }
                } else if m.text?.contains("手机号") ?? false {
                    textField.keyboardType = .numberPad
                    textField.setCheck { (tf) -> Bool in
                        let r = Tools.searchStr(str: tf.text ?? "", regexStr: "(^\\d{11}$)")
                        return r != nil
                    }
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
