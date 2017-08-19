//
//  ModifyPwdVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class ModifyPwdVC: BaseViewController {
    @IBOutlet weak var bvView: UIView!
    @IBOutlet weak var pwd1: CheckTextFiled!
    @IBOutlet weak var pwd2: CheckTextFiled!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isUpdateUserPwd = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bvView.layer.cornerRadius = 4
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        pwd1.setCheck({Tools.stringIsNotBlank(text: $0.text)})
        pwd2.setCheck({Tools.stringIsNotBlank(text: $0.text)})
        
        if !isUpdateUserPwd {
            self.titleLabel.text = "请修改支付密码"
        }
    }
    
    @IBAction func ac_save(_ sender: UIButton) {
        if !pwd1.check() || !pwd2.check() {
            return
        }
        
        if pwd1.text != pwd2.text {
            MBProgressHUD.show(errorText: "两次密码输入不一致")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var params = ["method":"apieditmyinofbysms", "fUserpass":self.pwd1.text!.MD5.uppercased()]
        params["fActiontype"] = isUpdateUserPwd ? "u" : "p"
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hide(for: self.view, animated: true)
            bm.whenSuccess {
                self.dismiss(animated: true, completion: nil)
            }
        }) { (err) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let p = touches.first?.location(in: self.view) ?? CGPoint.zero
        if !bvView.frame.contains(p) {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
