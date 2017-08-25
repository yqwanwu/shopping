//
//  PwdPhoneView.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class PwdPhoneView: UIView {

    @IBOutlet weak var phoneText: CheckTextFiled!
    @IBOutlet weak var codeText: CheckTextFiled!
    @IBOutlet weak var pwdText: CheckTextFiled!
    
    @IBOutlet weak var codeBtn: CountdownButton!
    
    var nextAction: BLANK_CLOSURE?
    var codeType = CodeModel.captChaType.b
    @IBAction func ac_getCode(_ sender: UIButton) {
        if !phoneText.check() || sender.isSelected {
            return
        }
        sender.isSelected = true
        CodeModel.requestData(phone: self.phoneText.text!, type: codeType)
    }

    
    @IBAction func ac_next(_ sender: UIButton) {
        nextAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        
        phoneText.setCheck { (tf) -> Bool in
            let r = Tools.searchStr(str: tf.text ?? "", regexStr: "(^\\d{11}$)")
            return r != nil
        }
        pwdText.setCheck { (tf) -> Bool in
            let c = (tf.text ?? "").characters.count
            return c < 15 && c > 5
        }
        codeText.setCheck { (tf) -> Bool in
            return Tools.stringIsNotBlank(text: tf.text)
        }
    }
    
}
