//
//  LoginVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/24.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    @IBOutlet weak var headerImgBack: UIView!
    @IBOutlet weak var textBack: UIView!
    @IBOutlet weak var phonrText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var autoLoginBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func ac_autoLogin(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
   
    @IBAction func loginByQQ(_ sender: MineButton) {
    }
    
    @IBAction func loginByWx(_ sender: MineButton) {
    }
    
    @IBAction func loginByTb(_ sender: MineButton) {
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















