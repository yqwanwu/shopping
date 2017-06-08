//
//  WaitVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class WaitVC: BaseViewController {
    @IBOutlet weak var tipLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tipLabel.text = "申请已提交，\n请耐心等待客服处理"
    }

}
