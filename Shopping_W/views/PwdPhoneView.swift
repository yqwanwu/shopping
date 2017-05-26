//
//  PwdPhoneView.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class PwdPhoneView: UIView {

    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet weak var codeBtn: CountdownButton!
    
    @IBAction func ac_getCode(_ sender: UIButton) {
        sender.isSelected = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
