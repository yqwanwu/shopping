//
//  ModifyPwdVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ModifyPwdVC: BaseViewController {
    @IBOutlet weak var bvView: UIView!
    @IBOutlet weak var pwd1: CheckTextFiled!
    @IBOutlet weak var pwd2: CheckTextFiled!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bvView.layer.cornerRadius = 4
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    @IBAction func ac_save(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let p = touches.first?.location(in: self.view) ?? CGPoint.zero
        if !bvView.frame.contains(p) {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
