//
//  ReturnedDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ReturnedDetailVC: BaseViewController {
    @IBOutlet var topBtnArr: [UIButton]!
    @IBOutlet weak var reasonText: PlacehodelTextView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        reasonText.placehoderLabel?.text = "请填写退换货理由"
        reasonText.layer.cornerRadius = CustomValue.btnCornerRadius
        photoView.layer.cornerRadius = CustomValue.btnCornerRadius
        uploadBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        topBtnArr.first?.isSelected = true
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
    }
    
    
    @IBAction func ac_return(_ sender: UIButton) {
        for btn in topBtnArr {
            btn.isSelected = false
        }
        sender.isSelected = true
    }
    
    @IBAction func ac_change(_ sender: UIButton) {
        for btn in topBtnArr {
            btn.isSelected = false
        }
        sender.isSelected = true
    }
    
    @IBAction func ac_uploadPhoto(_ sender: UIButton) {
        
    }

    @IBAction func ac_submit(_ sender: UIButton) {
        
    }
}
