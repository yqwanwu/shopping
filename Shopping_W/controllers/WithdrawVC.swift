//
//  WithdrawVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class WithdrawVC: BaseViewController {
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!//余额
    @IBOutlet weak var freezeLabel: UILabel!//冻结金额
    @IBOutlet weak var withDrawLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var tipText: UITextView!
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
    var moneyData: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        tipText.text = "账户余额是指当前账号中余额总数\n冻结金额在达到条件后会自动解冻\n可提现金额是指当前能提现的金额"
        
        if let j = moneyData {
            balanceLabel.text = "\(j["fAmount"].intValue)"
            freezeLabel.text = "\(j["fFrozenamount"].intValue)"
            withDrawLabel.text = "\(j["fCancashamount"].intValue)"
        }
        self.title = "提现"
    }
    @IBAction func acAddCard(_ sender: UIButton) {
        if RegionModel.findAllProvince().isEmpty {
            MBProgressHUD.show(errorText: "地址数据尚未初始化完成，请稍后近进入")
            return
        }
        let s = UIStoryboard(name: "AddCardVC", bundle: Bundle.main)
        let vc = s.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BankCardListVC {
            vc.selectedAction = { model in
                self.cardBtn.setTitle("\(model.fBankname)(\(model.fMaskaccount))", for: .normal)
            }
        }
    }
    
    @IBAction func ac_commit(_ sender: UIButton) {
        
    }
}
