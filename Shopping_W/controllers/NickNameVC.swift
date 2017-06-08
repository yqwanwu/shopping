//
//  NickNameVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class NickNameVC: BaseViewController {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bkView.layer.cornerRadius = 4
        nickNameTF.layer.cornerRadius = 2
        nickNameTF.becomeFirstResponder()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        tipLabel.isHidden = true
    }

    @IBAction func ac_submit(_ sender: UIButton) {
        if Tools.stringIsNotBlank(text: nickNameTF.text) {
            self.dismiss(animated: true, completion: nil)
        } else {
            tipLabel.isHidden = false
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let p = touches.first?.location(in: self.view) ?? CGPoint.zero
        
        if !bkView.frame.contains(p) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
