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
    
    @IBOutlet weak var qqBtn: MineButton!
    @IBOutlet weak var wxBtn: MineButton!
    @IBOutlet weak var tbBtn: MineButton!
    @IBOutlet weak var thirdLoginTitle: UILabel!
    

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qqBtn.isHidden = !CustomValue.isQQInsted
        wxBtn.isHidden = !CustomValue.isWXInsted
        tbBtn.isHidden = !CustomValue.isTBInsted
        if qqBtn.isHidden && wxBtn.isHidden && tbBtn.isHidden {
            thirdLoginTitle.isHidden = true
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
        //淘宝
        ALBBSDK.sharedInstance().albbsdkInit()
        ALBBSDK.sharedInstance().login(by: URL(string: "tbopen24030927"))
        ALBBSDK.sharedInstance().setAppkey("24030927")
        ALBBSDK.sharedInstance().setAuthOption(AuthOption(2))
        
        
        ALBBSDK.sharedInstance().auth(self, successCallback: { (session) in
            let u = session?.getUser()
            print("\(u?.nick)   \(u?.avatarUrl)   ")
        }) { (session, err) in
          print(session)
        }
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















