//
//  ForgetPwdVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class PwdQuestion: CustomTableViewCellItem {
    var fQuestionid = 0 //问题ID
    var fQuestioncontent = "" //问题名称
    var fOrder = 0
    var fState = 0
    
    var answer = ""
}

class ForgetPwdVC: BaseViewController {
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var bkVIew: UIView!
    @IBOutlet weak var pwdBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var segment: CustomSegment!
    @IBOutlet weak var questionView: CustomTableView!
    
    var pwdPhoneView: PwdPhoneView!
    
    var isModify = false
    var selectPhone = true
    
    var quetions = [PwdQuestion]()
    var selectedQuestions = [PwdQuestion(), PwdQuestion(), PwdQuestion()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        bkVIew.snp.updateConstraints { (make) in
            make.height.equalTo(203)
        }
        phoneView.isHidden = false
        
        pwdPhoneView = Bundle.main.loadNibNamed("PwdPhoneView", owner: nil, options: nil)?[0] as! PwdPhoneView
        phoneView.addSubview(pwdPhoneView)
        
        pwdPhoneView.snp.makeConstraints { [unowned self] (make) in
            make.top.bottom.left.right.equalTo(self.phoneView)
        }
        
        saveBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        requestData()
    }
    
    func requestData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestListModel(params: ["method":"apiquestions"]).setSuccessAction { (bm: BaseModel<PwdQuestion>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                self.quetions = bm.list!
               
//                var arr = [PwdQuestion]()
//                for model in bm.list! {
//                    let titleModel = PwdQuestion()
//                    titleModel.build(text: model.fQuestioncontent)
//                    model.build(text: model.fQuestioncontent).build(detailText: "")
//                    arr.append(titleModel)
//                    arr.append(model)
//                }
//                let qarr = arr.map { (c) -> PwdQuestion in
//                    return c.build(cellClass: PwdQuestionTableViewCell.self).build(heightForRow: 50).build(isFromStoryBord: true)
//                }
//                self.questionView.dataArray = [qarr]
//                self.questionView.reloadData()
            }
        }
    }
    
    func setupUI() {
        segment.addItem(item: phoneBtn)
        segment.addItem(item: pwdBtn)
        segment.selectedBackgroundColor = UIColor.hexStringToColor(hexString: "eaeaea")
        segment.selectedIndex = 0
        bkVIew.layer.cornerRadius = CustomValue.btnCornerRadius
        bkVIew.layer.borderColor = UIColor.hexStringToColor(hexString: "9d9d9d").cgColor
        bkVIew.layer.borderWidth = 1
        segment.layer.borderColor = UIColor.hexStringToColor(hexString: "9d9d9d").cgColor
        segment.layer.borderWidth = 1
        
        let c = PwdQuestion().build(text: "密保问题1: 请选择").build(accessoryType: .disclosureIndicator)
        let c1 = PwdQuestion().build(text: "密保问题1:").build(detailText: "")
        let c2 = PwdQuestion().build(text: "密保问题2: 请选择").build(accessoryType: .disclosureIndicator)
        let c3 = PwdQuestion().build(text: "密保问题2:").build(detailText: "")
        let c4 = PwdQuestion().build(text: "密保问题3: 请选择").build(accessoryType: .disclosureIndicator)
        let c5 = PwdQuestion().build(text: "密保问题3:").build(detailText: "")
        
        let data = [c, c1, c2, c3, c4, c5].map { (c) -> CustomTableViewCellItem in
            c.build(cellClass: PwdQuestionTableViewCell.self).build(heightForRow: 50).build(isFromStoryBord: true)
            if c.detailText == nil {
                c.setupCellAction({ [unowned self] (idx) in
                    let vc = QuestionVC()
                    vc.models = self.quetions.filter({ (q) -> Bool in
                        if self.selectedQuestions[idx.row / 2] != q {
                            for m in self.selectedQuestions {
                                if m.fQuestionid == q.fQuestionid {
                                    return false
                                }
                            }
                        }
                        return true
                    })
                    if !self.quetions.isEmpty {
                        vc.selectedAction = { [unowned self] model in
                            if self.selectedQuestions.count >= 3 {
                                self.selectedQuestions[idx.row / 2] = model
                            }
                            c.text = model.fQuestioncontent
                            self.questionView.reloadRows(at: [idx], with: .automatic)
                        }
                        self.present(vc, animated: true, completion: nil)
                    }
                })
            }
            return c
        }
        
        questionView.dataArray = [data]
        
    }

    @IBAction func ac_phoneClick(_ sender: UIButton) {
        //356 203
        bkVIew.snp.updateConstraints { (make) in
            make.height.equalTo(203)
        }
        
        phoneView.isHidden = false
    }
 
    @IBAction func ac_pwdClick(_ sender: UIButton) {
        bkVIew.snp.updateConstraints { (make) in
            make.height.equalTo(356)
        }
        phoneView.isHidden = true
    }

    //下一步
    @IBAction func ac_save(_ sender: UIButton) {
        var params = ["method":"apiSecurityEntry", "":""]
        if segment.selectedIndex == 0 {
            if !self.pwdPhoneView.phoneText.check() || !self.pwdPhoneView.codeText.check() || !self.pwdPhoneView.pwdText.check() {
                return
            }
            
            params["fActiontype"] = "u"
            params["smsCode"] = self.pwdPhoneView.codeText.text
            MBProgressHUD.showAdded(to: self.view, animated: true)
            NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
                MBProgressHUD.hideHUD(forView: self.view)
                bm.whenSuccess {
                    self.navigationController?.popViewController(animated: true)
                }
            }, failture: { (err) in
                MBProgressHUD.hideHUD(forView: self.view)
            })
        } else {
            for m in self.selectedQuestions {
                if !Tools.stringIsNotBlank(text: m.answer) || m.fQuestionid == 0 {
                    MBProgressHUD.show(errorText: "请回答所有保密问题")
                    return
                }

                MBProgressHUD.showAdded(to: self.view, animated: true)
                let params = ["method":"apiSecurityEntry", "fActiontype":"q", "fAnswer1":selectedQuestions[0].answer, "fAnswer2":selectedQuestions[1].answer, "fAnswer3":selectedQuestions[2].answer]
                NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
                    MBProgressHUD.hideHUD(forView: self.view)
                    bm.whenSuccess {
                        MBProgressHUD.show(successText: "aaaa")
                    }
                }, failture: { (err) in
                    MBProgressHUD.hideHUD(forView: self.view)
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.selectPhone {
            ac_pwdClick(pwdBtn)
            segment.selectedIndex = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let p = touches.first?.location(in: self.view) ?? CGPoint.zero
        
//        if !bkVIew.frame.contains(p) {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
}






















