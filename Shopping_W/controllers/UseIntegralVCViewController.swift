//
//  UseIntegralVCViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/28.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class UseIntegralVCViewController: BaseViewController {
    @IBOutlet weak var intergralTF: UITextField!
    @IBOutlet weak var btn: UIButton!
    
    var total = 0
    
    var submitAction: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        btn.layer.cornerRadius = CustomValue.btnCornerRadius
        intergralTF.addTarget(self, action: #selector(UseIntegralVCViewController.textChange), for: .editingChanged)
        
        requestInteral()
    }
    
    func textChange() {
        var num = Int(intergralTF.text ?? "") ?? 0
        if num > total {
            num = total
        } else if num < 0 {
            num = 0
        }
        
        intergralTF.text = "\(num)"
    }

    @IBAction func ac_submit(_ sender: Any) {
        var num = Int(intergralTF.text ?? "") ?? 0
        submitAction?(num)
    }
    
    func requestInteral() {
        /*
         method	string	apimyintegrals	无
         fSum	int	自行获取	0或1，传入 0 或不传表示去列表以及合计，传入1 表示只取合计
         */
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestListModel(params: ["method":"apimyintegrals"])
            .setSuccessAction { (bm: BaseModel<MyIntegralModel>) in
                bm.whenSuccess { [unowned self] _ in
                    self.intergralTF.placeholder = "可用积分 : " + bm.ai
                    self.total = Int(bm.ai) ?? 0
                }
                
                MBProgressHUD.hideHUD(forView: self.view)
        }
    }
}
