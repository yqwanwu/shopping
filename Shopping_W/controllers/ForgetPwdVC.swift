//
//  ForgetPwdVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import SnapKit

class PwdQuestion: CustomTableViewCellItem {
    var fQuestionid = 0 //问题ID
    var fQuestioncontent = "" //问题名称
    var fOrder = 0
    var fState = 0
    
    var answer = ""
}

class ForgetPwdVC: BaseViewController {
    enum PwdViewType {
        case onlyPhone, onlyQuesion, all
    }
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var bkVIew: UIView!
    @IBOutlet weak var pwdBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var segment: CustomSegment!
    @IBOutlet weak var questionView: CustomTableView!
    
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var bkHeight: NSLayoutConstraint!
    var pwdPhoneView: PwdPhoneView!
    var type = CodeModel.captChaType.b
    var viewType = PwdViewType.all
    var isModify = false
    var selectPhone = true
    
    var canWritePhone = false
    
    var isFirstSave = false
    
    var model: ForgetUserPassModel?
    
    var quetions = [PwdQuestion]()
    var selectedQuestions = [PwdQuestion(), PwdQuestion(), PwdQuestion()]
    var showOnlyOne = false
    
    let c = PwdQuestion().build(text: "密保问题1: 请选择").build(accessoryType: .disclosureIndicator)
    let c1 = PwdQuestion().build(text: "密保问题1:").build(detailText: "")
    let c2 = PwdQuestion().build(text: "密保问题2: 请选择").build(accessoryType: .disclosureIndicator)
    let c3 = PwdQuestion().build(text: "密保问题2:").build(detailText: "")
    let c4 = PwdQuestion().build(text: "密保问题3: 请选择").build(accessoryType: .disclosureIndicator)
    let c5 = PwdQuestion().build(text: "密保问题3:").build(detailText: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        bkVIew.snp.updateConstraints { (make) in
            make.height.equalTo(152)
        }
        phoneView.isHidden = false
        
        pwdPhoneView = Bundle.main.loadNibNamed("PwdPhoneView", owner: nil, options: nil)?[0] as! PwdPhoneView
        phoneView.addSubview(pwdPhoneView)
        
        pwdPhoneView.snp.makeConstraints { [unowned self] (make) in
            make.top.bottom.left.right.equalTo(self.phoneView)
        }
        pwdPhoneView.codeType = type
        saveBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        
        if !canWritePhone {
            pwdPhoneView.phoneText.isEnabled = false
            
            if let p = PersonMdel.readData() {
                pwdPhoneView.phoneText.text = p.fPhone
            }
        }
        
        if showOnlyOne {
            self.saveBtn.setTitle("保存", for: .normal)
            segmentHeight.constant = 0
            if type == .t {
                self.segment.selectedIndex = 0
                self.title = "修改手机号码"
            } else if type == .m {
                self.segment.selectedIndex = 1
                self.title = "修改密保"
                self.selectPhone = false
                bkHeight.constant -= 50
            }
            bkVIew.snp.updateConstraints { (make) in
                make.height.equalTo(101)
            }
        }
        
        setView()
        
        if viewType != .all {
            let coverLabel = UILabel()
            coverLabel.backgroundColor = UIColor.white
            coverLabel.textAlignment = .center
            coverLabel.isUserInteractionEnabled = true
            segment.addSubview(coverLabel)
            coverLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            if viewType == .onlyPhone {
                coverLabel.text = "手机"
                self.title = "找回密码"
                return
            } else if viewType == .onlyQuesion {
                coverLabel.text = "密保"
                self.title = "找回密码"
            }
        }
        requestData()
    }
    
    func setView() {
        if let m = model {
            self.pwdPhoneView.phoneText.text = m.fPhone
        }
    }
    
    func requestData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestListModel(params: ["method":"apiquestions"]).setSuccessAction { (bm: BaseModel<PwdQuestion>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                self.quetions = bm.list!
                self.setupQuestions()
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
    
    func setupQuestions() {
        let models = self.quetions
        var answerIds = [Int]()
        if let p = PersonMdel.readData() {
            answerIds = [p.fAnswer1, p.fAnswer2, p.fAnswer3]
        } else if let m = model {
            answerIds = [m.fAnswer1, m.fAnswer2, m.fAnswer3]
        }
        
        if answerIds[0] != 0 {
            selectedQuestions = models.filter({ $0.fQuestionid == answerIds[0] || $0.fQuestionid == answerIds[1] || $0.fQuestionid == answerIds[2] })
            c.text = selectedQuestions[0].fQuestioncontent
            c2.text = selectedQuestions[1].fQuestioncontent
            c4.text = selectedQuestions[2].fQuestioncontent
        } else {
            isFirstSave = true
            self.saveBtn.setTitle("保存", for: .normal)
        }
        
        let data = [c, c1, c2, c3, c4, c5].map { (c) -> CustomTableViewCellItem in
            c.build(cellClass: PwdQuestionTableViewCell.self).build(heightForRow: 50).build(isFromStoryBord: true)
            
            if c.detailText == nil && isFirstSave {
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
        questionView.reloadData()
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
    }

    @IBAction func ac_phoneClick(_ sender: UIButton) {
        //356 203
        bkVIew.snp.updateConstraints { (make) in
            make.height.equalTo(152)
        }
        
        phoneView.isHidden = false
    }
 
    @IBAction func ac_pwdClick(_ sender: UIButton) {
        bkVIew.snp.updateConstraints { (make) in
            make.height.equalTo(356)
        }
        phoneView.isHidden = true
    }
    
    func saveQuestions() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["method":"apieditmyinofbysms", "fActiontype":"q", "fAnswer1":self.getAnsewerStr(q: selectedQuestions[0]), "fAnswer2":self.getAnsewerStr(q: selectedQuestions[1]), "fAnswer3":self.getAnsewerStr(q: selectedQuestions[2])]
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                if let p = PersonMdel.readData() {
                    p.fAnswer1 = self.selectedQuestions[0].fQuestionid
                    p.fAnswer2 = self.selectedQuestions[1].fQuestionid
                    p.fAnswer3 = self.selectedQuestions[2].fQuestionid
                }
                for vc in (self.navigationController?.viewControllers)! {
                    if vc is SafeCenterVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
        }, failture: { (err) in
            MBProgressHUD.hideHUD(forView: self.view)
        })
    }

    //下一步  后台改版好几次，很烦，只能将就写，
    @IBAction func ac_save(_ sender: UIButton) {
        if segment.selectedIndex == 0 {
            if !self.pwdPhoneView.phoneText.check() || !self.pwdPhoneView.codeText.check() {
                return
            }
        } else {
            selectedQuestions[0].answer = c1.answer
            selectedQuestions[1].answer = c3.answer
            selectedQuestions[2].answer = c5.answer
            for m in self.selectedQuestions {
                if !Tools.stringIsNotBlank(text: m.answer) || m.fQuestionid == 0 {
                    MBProgressHUD.show(errorText: "请回答所有保密问题")
                    return
                }
            }
        }
        
        if isFirstSave {
            saveQuestions()
            return
        }
        
        //忘记密码界面
        if let m = model, viewType != .all {
            var params = ["method": "apiCheckForForget", "fPhone": m.fPhone]
            if viewType == .onlyPhone {
                params["fActiontype"] = "m"
                params["smsCode"] = pwdPhoneView.codeText.text ?? ""
            } else {
                params["fActiontype"] = "q"
                params["fAnswer1"] = self.getAnsewerStr(q: selectedQuestions[0])
                params["fAnswer2"] = self.getAnsewerStr(q: selectedQuestions[1])
                params["fAnswer3"] = self.getAnsewerStr(q: selectedQuestions[2])
            }
            
            NetworkManager.requestTModel(params: params).setSuccessAction(action: { (bm: BaseModel<CodeModel>) in
                bm.whenSuccess {
                    let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: ModifyPwdVC.self)
                    vc.isUpdateUserPwd = true
                    vc.forgetModel = self.model
                    vc.topVC = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            return
        }
        
        if showOnlyOne {
            if segment.selectedIndex == 0 {
                var params = ["method":"apieditmyinofbysms", "fActiontype":"m"]
                params["smsCode"] = self.pwdPhoneView.codeText.text!
                MBProgressHUD.showAdded(to: self.view, animated: true)
                NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
                    MBProgressHUD.hideHUD(forView: self.view)
                    bm.whenSuccess {
                        for vc in (self.navigationController?.viewControllers)! {
                            if vc is SafeCenterVC {
                                self.navigationController?.popToViewController(vc, animated: true)
                                break
                            }
                        }
                    }
                }, failture: { (err) in
                    MBProgressHUD.hideHUD(forView: self.view)
                })
            } else {
                saveQuestions()
            }
            return
        }
        
        var vc: UIViewController!
        if type == .c || type == .p {
            vc = Tools.getClassFromStorybord(sbName: .mine, clazz: ModifyPwdVC.self)
            (vc as! ModifyPwdVC).isUpdateUserPwd = (type == .c)
        } else {
            vc = Tools.getClassFromStorybord(sbName: .main, clazz: ForgetPwdVC.self)
            let fvc = vc as! ForgetPwdVC
            fvc.showOnlyOne = true
            fvc.type = type
            canWritePhone = true
        }
        
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if segment.selectedIndex == 0 {
            var params = ["method":"apiSecurityEntry", "fActiontype":"m"]
            params["smsCode"] = self.pwdPhoneView.codeText.text!
            MBProgressHUD.showAdded(to: self.view, animated: true)
            NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
                MBProgressHUD.hideHUD(forView: self.view)
                bm.whenSuccess {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, failture: { (err) in
                MBProgressHUD.hideHUD(forView: self.view)
            })
        } else {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let params = ["method":"apiSecurityEntry", "fActiontype":"q", "fAnswer1":self.getAnsewerStr(q: selectedQuestions[0]), "fAnswer2":self.getAnsewerStr(q: selectedQuestions[1]), "fAnswer3":self.getAnsewerStr(q: selectedQuestions[2])]
            NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
                MBProgressHUD.hideHUD(forView: self.view)
                bm.whenSuccess {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, failture: { (err) in
                MBProgressHUD.hideHUD(forView: self.view)
            })
        }
    }
    
    func getAnsewerStr(q: PwdQuestion) -> String {
        return "\(q.fQuestionid)#\(q.answer)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.selectPhone || viewType == .onlyQuesion {
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






















