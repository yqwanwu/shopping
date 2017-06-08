//
//  PayResultVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class PayResultVC: BaseViewController {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thankLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var bkView: UIView!

    @IBOutlet weak var titleCenterY: NSLayoutConstraint!
    var isSuccess = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isSuccess {
            submitBtn.setTitle("请重新支付", for: .normal)
            tipLabel.isHidden = true
            thankLabel.isHidden = true
            icon.image = #imageLiteral(resourceName: "支付失败")
            titleLabel.text = "支付失败"
            bkView.backgroundColor = UIColor.hexStringToColor(hexString: "555555")
            titleCenterY.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func ac_submit(_ sender: Any) {
        if isSuccess {
            var vc = (self.navigationController?.viewControllers.first)!
            for v in (self.navigationController?.viewControllers)! {
                if let v = v as? OrderVC {
                    vc = v
                    v.selectedIndex = 0
                }
            }
            self.navigationController?.popToViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
