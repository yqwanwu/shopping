//
//  PwdRouteVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/10/19.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class ForgetUserPassModel: CustomTableViewCellItem {
    static var defaultValue = ForgetUserPassModel()
    
    var fAnswer2 = 0
    var fAnswer3 = 0
    var fAnswer1 = 0
    var fHaveAnswer = false
    var fPhone = ""
}

class PwdRouteVC: BaseViewController {
    @IBOutlet weak var userNameTF: CheckTextFiled!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var bkHeight: NSLayoutConstraint!
    @IBOutlet weak var questionBtn: UIButton!
    var canEnterUserName = true
    var model: ForgetUserPassModel?
    
    var isShowSelectBtn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        if !isShowSelectBtn {
            bkHeight.constant = 0
        }
        userNameTF.isEnabled = canEnterUserName
        phoneBtn.isSelected = true
        if let m = model {
            userNameTF.text = m.fPhone
        }
        title = "找回密码"
    }

    @IBAction func ac_phone(_ sender: UIButton) {
        phoneBtn.isSelected = false
        questionBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func ac_next(_ sender: Any) {
        if questionBtn.isSelected {
            if let m = model {
                if !m.fHaveAnswer {
                    MBProgressHUD.show(errorText: "您没有设置过密保问题")
                    return
                }
            }
        }
        
        if !Tools.stringIsNotBlank(text: userNameTF.text) {
            MBProgressHUD.show(errorText: "请输入手机号或者用户名")
            return
        }
        if !isShowSelectBtn {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            NetworkManager.requestTModel(params: ["method": "apiForgetUserPass", "uName": userNameTF.text ?? ""]).setSuccessAction { (bm: BaseModel<ForgetUserPassModel>) in
                MBProgressHUD.hideHUD(forView: self.view)
                bm.whenSuccess {
                    self.model = bm.t!
                    let vc = PwdRouteVC()
                    vc.canEnterUserName = false
                    vc.isShowSelectBtn = true
                    vc.model = self.model
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: ForgetPwdVC.self)
            vc.viewType = phoneBtn.isSelected ? .onlyPhone : .onlyQuesion
            vc.type = .c
            vc.model = self.model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    
}
