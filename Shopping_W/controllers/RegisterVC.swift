//
//  RegisterVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterVC: BaseViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: CustomTableView!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    weak var loginVC: LoginVC?
    
    var textFieldList = [CheckTextFiled]()
    
    let c = CustomTableViewCellItem().build(text: "用户名:").build(detailText: "请输入用户名")
    let c1 = CustomTableViewCellItem().build(text: "密码:").build(detailText: "密码6-14位")
    let c2 = CustomTableViewCellItem().build(text: "确认密码:").build(detailText: "密码6-14位")
    let c3 = CustomTableViewCellItem().build(text: "手机号:").build(detailText: "请输入手机号")
    let c4 = CodeModel()
        .build(text: "验证码:").build(heightForRow: 50)
        .build(isFromStoryBord: true)
        .build(cellClass: RegisterCodeTableViewCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        setupTableView()
    }

    func setupTableView() {
        tableView.sectionHeaderHeight = 10
        
        var datas = [[c, c1, c2, c3]].map({ (item) -> [CustomTableViewCellItem] in
            return item.map({ (c) -> CustomTableViewCellItem in
                c.build(cellClass: RegisterTableViewCell.self)
                    .build(isFromStoryBord: true)
                    .build(heightForRow: 50)
            })
        })
        
        datas[0].append(c4)
        
        tableView.dataArray = datas
        tableView.dataSource = self
    }
    
    @IBAction func ac_register(_ sender: UIButton) {
        for tf in textFieldList {
            if !tf.check() {
                return
            }
        }
        
        if textFieldList[1].text != textFieldList[2].text {
            MBProgressHUD.show(errorText: "两次密码不一致")
            return
        }
        
        let phone = textFieldList[3].text ?? ""
        
        let upperStr = (textFieldList[1].text ?? "").MD5.uppercased()
        
        let p = ["method":"apiuserreg", "phone":phone, "name":textFieldList[0].text ?? "", "pass":upperStr, "phonecode":textFieldList[4].text ?? ""]
        
        MBProgressHUD.show()
        NetworkManager.JsonPostRequest(params: p, success: { (json) in
            MBProgressHUD.hideHUD()
            if json["code"].intValue == 0 {
                self.loginVC?.phonrText.text = phone
                self.loginVC?.pwdText.text = self.textFieldList[1].text ?? ""
                self.navigationController?.popViewController(animated: true)
            } else {
                MBProgressHUD.show(errorText: json["message"].stringValue)
            }
        }) { (err) in
            MBProgressHUD.hideHUD()
            MBProgressHUD.show(errorText: "请求失败")
        }
    }

}

extension RegisterVC {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.createDefaultCell(indexPath: indexPath)
        
        if let cell = cell as? RegisterTableViewCell {
            textFieldList.insert(cell.textField, at: indexPath.row)
            if indexPath.row == 3 {
                c4.getCodeAction = {
                    if !cell.textField.check() {
                     return ""
                    }
                    return cell.textField.text ?? ""
                }
            }
        } else if let cell = cell as? RegisterCodeTableViewCell {
            textFieldList.insert(cell.codeTF, at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }
}














