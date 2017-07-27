//
//  ForgetPwdVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class PwdQuestion: CustomTableViewCellItem {
    var fQuestionid = 0 //问题ID
    var fQuestioncontent = "" //问题名称
    var fOrder = 0
    var fState = 0
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
        NetworkManager.requestListModel(params: ["method":"apiquestions"]).setSuccessAction { (bm: BaseModel<PwdQuestion>) in
            bm.whenSuccess {
                var arr = [PwdQuestion]()
                for model in bm.list! {
                    let titleModel = PwdQuestion()
                    titleModel.build(text: model.fQuestioncontent)
                    model.build(text: model.fQuestioncontent).build(text: "")
                    arr.append(titleModel)
                    arr.append(model)
                }
                let qarr = arr.map { (c) -> PwdQuestion in
                    return c.build(cellClass: PwdQuestionTableViewCell.self).build(heightForRow: 50).build(isFromStoryBord: true)
                }
                self.questionView.dataArray = [qarr]
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
        
//        let c = CustomTableViewCellItem().build(text: "密保问题1: 你最喜欢的电影名称")
//        let c1 = CustomTableViewCellItem().build(text: "密保问题1:").build(detailText: "")
//        let c2 = CustomTableViewCellItem().build(text: "密保问题2: 你爸爸的姓名")
//        let c3 = CustomTableViewCellItem().build(text: "密保问题2:").build(detailText: "")
//        let c4 = CustomTableViewCellItem().build(text: "密保问题3: 你爸爸的手机号")
//        let c5 = CustomTableViewCellItem().build(text: "密保问题3:").build(detailText: "")
//        
//        let data = [c, c1, c2, c3, c4, c5].map { (c) -> CustomTableViewCellItem in
//            return c.build(cellClass: PwdQuestionTableViewCell.self).build(heightForRow: 50).build(isFromStoryBord: true)
//        }
//        
//        questionView.dataArray = [data]
        
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

    @IBAction func ac_save(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.selectPhone {
            ac_pwdClick(pwdBtn)
            segment.selectedIndex = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let p = touches.first?.location(in: self.view) ?? CGPoint.zero
        
        if !bkVIew.frame.contains(p) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}






















