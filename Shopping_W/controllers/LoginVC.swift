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
//    @IBOutlet weak var tbBtn: MineButton!
    @IBOutlet weak var thirdLoginTitle: UILabel!
    
    var loginSuccessAction: BLANK_CLOSURE?
    
    let k_toRegisterVC = "toRegisterVC"
    
    override func viewDidLoad() {
        self.showFirstVCBackBtn = true
        super.viewDidLoad()
//        phonrText.setCheck { (tf) -> Bool in
//            let r = Tools.searchStr(str: tf.text ?? "", regexStr: "(^\\d{11}$)")
//            return r != nil
//        }
        pwdText.setCheck { (tf) -> Bool in
            let c = (tf.text ?? "").characters.count
            return c < 15 && c > 5
        }
        
        self.autoLoginBtn.isSelected = true
        
        if let p = PersonMdel.readData() {
            self.autoLoginBtn.isSelected = p.isAutoLogin
            
            if p.isAutoLogin {
                self.phonrText.text = p.fPhone
                self.pwdText.text = p.fUserpass
            }
        }
    }
    
    override func ac_back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qqBtn.isHidden = !CustomValue.isQQInsted
        wxBtn.isHidden = !CustomValue.isWXInsted
//        tbBtn.isHidden = !CustomValue.isTBInsted
        if qqBtn.isHidden && wxBtn.isHidden  {//&& tbBtn.isHidden
            thirdLoginTitle.isHidden = true
        }
    }
    
    
    static func login(userName: String, pwd: String, successAction: @escaping () -> Void) {
        let params = ["method":"apiuserlogin", "fUsername":userName, "fUserpass":pwd.MD5.uppercased()]
        NetworkManager.requestTModel(params: params, success: { (bm: BaseModel<PersonMdel>) in
            MBProgressHUD.hideHUD()
            MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow!, animated: true)
            bm.whenSuccess {
                bm.t?.fUserpass = pwd
                bm.t!.saveData()
                successAction()
                NetworkManager.sessionId = bm.sessionId
                
                //登陆后需要请求的数据
                AddressModel.requestData()
                CarModel.requestList()
                CarModel.addToServer()
            }
        }) { (err) in
            MBProgressHUD.hideHUD()
            MBProgressHUD.show(errorText: NetworkManager.REQUEST_ERROR)
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
    
    @IBAction func ac_pwd(_ sender: Any) {
        let vc = UIStoryboard(name: "PwdRouteVC", bundle: Bundle.main).instantiateViewController(withIdentifier: "PwdRouteVC")
//         = PwdRouteVC()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ac_login(_ sender: Any) {
        if !self.phonrText.check() || !self.pwdText.check() {
            return
        }
        
        MBProgressHUD.show(text: "登录中...")
        LoginVC.login(userName: phonrText.text ?? "", pwd: pwdText.text ?? "") {
//            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: CustomTabBarVC.self)
            self.dismiss(animated: true, completion: nil)
//            self.present(vc, animated: true, completion: nil)
            FirstViewController.isShowQuestion = true
            
            self.loginSuccessAction?()
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
    
    @discardableResult
    static func showLogin(successAction: BLANK_CLOSURE? = nil) -> Bool {
        if !PersonMdel.isLogined() {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVCNav") as! UINavigationController
            
            let lvc = vc.viewControllers.first! as! LoginVC
            lvc.loginSuccessAction = successAction
            
//            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: LoginVC.self)
            CustomTabBarVC.instance.present(vc, animated: true, completion: nil)
            return true
        }
        
        return false
    }
    
    
    //MARK: 重写
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupUI()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == k_toRegisterVC {
            let vc = segue.destination as! RegisterVC
            vc.loginVC = self
        } else if let vc = segue.destination as? ForgetPwdVC {
            vc.canWritePhone = true
        }
    }
    
}















