//
//  CodeModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class CodeModel: CustomTableViewCellItem {

    ///R注册 B找回登陆密码 T更换手机号码 C修改登录密码 P修改支付密码 M修改密保 F绑定手机
    enum captChaType: String {
        case r = "R", b = "B", t = "T", c = "C", p = "P", m = "M", f = "F"
    }
    
    var getCodeAction: () -> String = { "" }
    
    static func requestData(phone: String, type: captChaType) {
        NetworkManager.requestModel(params: ["method":"apiusersms", "phone":phone, "captChaType":type.rawValue], success: { (code: CodeModel) in
            if code.code != "0" {
                MBProgressHUD.show(errorText: code.message)
            } else {
                MBProgressHUD.show(successText: "已发送，请注意查收")
            }
        }) { (err) in
            MBProgressHUD.show(errorText: "请求失败")
        }
    }
    
}
