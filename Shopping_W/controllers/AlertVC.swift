//
//  AlertVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var bkView: UIView!
    
    
    var okAction: ((_ vc: AlertVC) -> Void)?
    var cancleAction: ((_ vc: AlertVC) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        bkView.layer.cornerRadius = 8
        tipLabel.text = "确认是否收到货物?\n否则可能造成财物两空"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self.view) ?? CGPoint.zero
        if !bkView.frame.contains(point) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func ac_ok(_ sender: Any) {
        okAction?(self)
    }
    @IBAction func ac_cancle(_ sender: Any) {
        cancleAction?(self)
    }
}
