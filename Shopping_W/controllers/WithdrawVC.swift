//
//  WithdrawVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class WithdrawVC: BaseViewController {
    @IBOutlet weak var balanceLabel: UILabel!//余额
    @IBOutlet weak var freezeLabel: UILabel!//冻结金额
    @IBOutlet weak var withDrawLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var tipText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        commitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        tipText.text = "账户余额是指当前账号中余额总数\n冻结金额在达到条件后会自动解冻\n可提现金额是指当前能提现的金额"
    }

    @IBAction func ac_commit(_ sender: UIButton) {
    }
}
