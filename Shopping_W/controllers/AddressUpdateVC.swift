//
//  AddressUpdateVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/27.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddressUpdateVC: UIViewController {
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var detailText: PlacehodelTextView!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var tagTF: UITextField!
    @IBOutlet weak var bkTop: NSLayoutConstraint!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    weak var topVC: ReviceAddressVC!
    
    var model: AddressModel?
    
    let addressPicker = LinkedPicker()
    let cancleBtn = UIButton(type: .system)
    let sureBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bkView.layer.cornerRadius = 8
        bkView.clipsToBounds = true
        detailText.layer.borderColor = UIColor.hexStringToColor(hexString: "f0f0f0").cgColor
        detailText.layer.borderWidth = 1
        detailText.layer.cornerRadius = 4
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        bkView.addSubview(addressPicker)
        addressPicker.backgroundColor = UIColor.white
        
        addressBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        mailTF.keyboardType = .numberPad
    }
    
    var pickerSeted = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let m = model {
            nameTF.text = m.fName
            phoneTF.text = m.fPhone
            let j = JSON(parseJSON: m.fAddressparams)
            let addressName = j["province"].stringValue + j["city"].stringValue + j["area"].stringValue
            addressBtn.setTitle(addressName, for: .normal)
            detailText.text = m.fAddress
            tagTF.text = m.fTagname
            
            addressPicker.setup(data: [j["province"].stringValue, j["city"].stringValue, j["area"].stringValue])
        } else {
            self.saveBtn.setTitle("保存", for: .normal)
            self.title = "添加地址"
        }
        
        if !pickerSeted {
            setupPicker()
            pickerSeted = true
        }
        
    }
    
    func setupPicker() {
        cancleBtn.setTitle("取消", for: .normal)
        sureBtn.setTitle("确定", for: .normal)
        
        cancleBtn.addTarget(self, action: #selector(AddressUpdateVC.ac_cancle), for: .touchUpInside)
        sureBtn.addTarget(self, action: #selector(AddressUpdateVC.ac_sure), for: .touchUpInside)
        
        bkView.addSubview(cancleBtn)
        bkView.addSubview(sureBtn)
        
        cancleBtn.isHidden = true
        sureBtn.isHidden = true
        
    }
    
    @IBAction func ac_cancle() {
        selectorClick()
    }
    
    @IBAction func ac_dismiss(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    
    func ac_sure() {
        selectorClick()
        
        let name = addressPicker.getAddressArr().joined(separator: "")
        self.addressBtn.setTitle(name, for: .normal)
    }
    
    @IBAction func ac_save(_ sender: Any) {
        let areaArr = addressPicker.getAddressArr()
        let area = NetworkManager.ObjToJson(obj: ["area":areaArr[2], "city":areaArr[1], "province":areaArr[0]])
        var params = ["method":"apiaddressadd", "fPhone":phoneTF.text ?? "", "fName":nameTF.text ?? "", "fAddressparams":area, "fTagname":tagTF.text ?? "", "fAddress":detailText.text ?? "", "fType":1] as [String:Any]
        
        if let m = model {
            params["fAddressid"] = m.fAddressid
            params["method"] = "apiaddressedit"
        }
        
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                self.view.removeFromSuperview()
                self.topVC.requestData()
            }
        }) { (err) in
            
        }
    }
    
    
    func selectorClick() {
        cancleBtn.isHidden = true
        sureBtn.isHidden = true
        UIView.animate(withDuration: 0.4) {
            self.addressPicker.frame.origin.x = self.addressPicker.frame.width
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !self.bkView.frame.contains((touches.first?.location(in: self.view))!) {
            self.resignFirstResponder()
        }
    }

    @IBAction func ac_showSelector(_ sender: UIButton) {
        cancleBtn.isHidden = false
        sureBtn.isHidden = false
        addressPicker.frame.origin.x = self.bkView.bounds.width
        UIView.animate(withDuration: 0.4) { 
            self.addressPicker.frame.origin.x = 0
        }
    }
    
    var showAnimated = false
    //MARK: 重写
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addressPicker.frame = self.bkView.bounds
        addressPicker.frame.origin.x = self.bkView.bounds.width
        cancleBtn.frame = CGRect(x: 10, y: 10, width: 50, height: 35)
        sureBtn.frame = CGRect(x: self.bkView.bounds.width - 60, y: 10, width: 50, height: 35)
    }
}

















