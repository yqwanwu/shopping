//
//  MessageVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/12.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class MessageVC: BaseViewController {
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var msgText: PlacehodelTextView! {
        didSet {
            msgText.layer.cornerRadius = 4
            msgText.layer.borderColor = UIColor.hexStringToColor(hexString: "888888").cgColor
            msgText.layer.borderWidth = 1
            msgText.placeholderText = "咨询内容"
            bkView.layer.cornerRadius = CustomValue.btnCornerRadius
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    @IBAction func ac_cancle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func ac_submit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let p = touches.first?.location(in: self.view) ?? CGPoint.zero
        
        if !bkView.frame.contains(p) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
