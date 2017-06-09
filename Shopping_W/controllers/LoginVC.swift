//
//  LoginVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/24.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginVC: BaseViewController {
    @IBOutlet weak var headerImgBack: UIView!
    @IBOutlet weak var textBack: UIView!
    @IBOutlet weak var phonrText: CheckTextFiled!
    @IBOutlet weak var pwdText: CheckTextFiled!
    @IBOutlet weak var autoLoginBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        phonrText.setCheck { (tf) -> Bool in
            let r = Tools.searchStr(str: tf.text ?? "", regexStr: "(^\\d{11}$)")
            return r != nil
        }
        pwdText.setCheck { (tf) -> Bool in
            let c = (tf.text ?? "").characters.count
            return c < 15 && c > 5
        }
    }
    

    @IBAction func ac_autoLogin(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
   
    @IBAction func loginByQQ(_ sender: MineButton) {
        
       UMSocialManager.default().getUserInfo(with: .QQ, currentViewController: self) { [unowned self] (result, err) in
            self.loginByUm(result: result, err: err)
        }
    }
    
    @IBAction func loginByWx(_ sender: MineButton) {
        UMSocialManager.default().getUserInfo(with: .wechatSession, currentViewController: self) { [unowned self] (result, err) in
            self.loginByUm(result: result, err: err)
        }
    }
    
    @IBAction func loginByTb(_ sender: MineButton) {
        
    }
    
    
    var p = PersonMdel()
    func loginByUm(result: Any?, err: Error?) {
        p = PersonMdel()
        if err != nil {
            MBProgressHUD.show(errorText: "登录失败")
        } else {
            if let resp = result as? UMSocialUserInfoResponse {
                print("\(resp.name)  \(resp.iconurl)  \(resp.unionGender)")
            } else {
                MBProgressHUD.show(errorText: "登录失败")
            }
        }
    }
    
    
    func setupUI() {
        headerImgBack.layer.cornerRadius = headerImgBack.frame.width / 2
        textBack.layer.borderColor = UIColor.hexStringToColor(hexString: "9D9D9D").cgColor
        textBack.layer.borderWidth = 1
        textBack.layer.cornerRadius = CustomValue.btnCornerRadius
        loginBtn.layer.cornerRadius = CustomValue.btnCornerRadius
    }
    
    //MARK: 重写
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupUI()
    }
    
    
}















