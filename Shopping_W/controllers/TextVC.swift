//
//  TextVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/23.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class TextVC: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var textView: PlacehodelTextView!
    @IBOutlet weak var btn: UIButton!

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.placehoderLabel?.text = "请输入建议"
    }

    @IBAction func ac_submit(_ sender: UIButton) {
        /*
         method	string	apiaddsuggestion	无
         fContactuser	string	前台获取	联 系 人，必填
         fContact	string	前台获取	联系电话，必填
         fContent	string	前台获取	建议内容，必填
 */
        guard let p = PersonMdel.readData() else {
            return
        }
        
        if !Tools.stringIsNotBlank(text: nameTF.text) {
            MBProgressHUD.show(warningText: "请输入姓名")
            return
        }
        
        if !Tools.stringIsNotBlank(text: phoneTF.text) {
            MBProgressHUD.show(warningText: "请输入联系电话")
            return
        }
        
        if !Tools.stringIsNotBlank(text: textView.text) {
            MBProgressHUD.show(warningText: "请输入建议")
            return
        }
        
        MBProgressHUD.show(text: "发送中", view: self.view, autoHide: false)
        NetworkManager.requestModel(params: ["method":"apiaddsuggestion", "fContactuser":nameTF.text!, "fContact":self.phoneTF.text!, "fContent":textView.text!], success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            if !bm.isSuccess {
                MBProgressHUD.show(errorText: bm.message)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            
        }
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.ac_submit(btn)
        }
        return true
    }
}
