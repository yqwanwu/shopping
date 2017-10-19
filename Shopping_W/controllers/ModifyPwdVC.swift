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
    
    var forgetModel: ForgetUserPassModel?
    var topVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bvView.layer.cornerRadius = 4
//        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        pwd1.setCheck({Tools.stringIsNotBlank(text: $0.text)})
        pwd2.setCheck({Tools.stringIsNotBlank(text: $0.text)})
        self.title = "请修改登录密码"
        if !isUpdateUserPwd {
            self.titleLabel.text = "请修改支付密码"
            self.title = "请修改支付密码"
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
        
        ///新加的接口
        if let m = forgetModel {
            let params = ["method": "apiChangePassForForget", "fPass": self.pwd1.text!.MD5.uppercased(), "fPhone": m.fPhone]
            NetworkManager.requestTModel(params: params).setSuccessAction(action: { (bm: BaseModel<CodeModel>) in
                bm.whenSuccess {
                    MBProgressHUD.show(successText: "重置成功")
                    self.navigationController?.popToRootViewController(animated: true)
                }
                if !bm.isSuccess {
                    let vcs = self.navigationController!.viewControllers
                    let vc = vcs[vcs.count - 3]
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            })
            return
        }
        
        ///这是原来的逻辑
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var params = ["method":"apieditmyinofbysms", "fUserpass":self.pwd1.text!.MD5.uppercased()]
        params["fActiontype"] = isUpdateUserPwd ? "u" : "p"
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hide(for: self.view, animated: true)
            bm.whenSuccess {
                if let p = PersonMdel.readData(), self.isUpdateUserPwd {
                    p.password = self.pwd1.text!
                }
                for vc in (self.navigationController?.viewControllers)! {
                    if vc is SafeCenterVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
        }) { (err) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let p = touches.first?.location(in: self.view) ?? CGPoint.zero
//        if !bvView.frame.contains(p) {
//            self.dismiss(animated: true, completion: nil)
//        }
    }

}
