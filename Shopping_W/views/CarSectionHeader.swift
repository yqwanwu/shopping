//
//  CarSectionHeader.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CarSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var selectAction: BLANK_CLOSURE?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //取消右边的箭头
        rightBtn.setImage(nil, for: .normal)
    }
    
    @IBAction func ac_select(_ sender: UIButton) {
        selectAction?()
    }
    
    @IBOutlet weak var ac_go: UIButton!
}
