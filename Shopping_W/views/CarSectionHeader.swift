//
//  CarSectionHeader.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CarSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func ac_select(_ sender: UIButton) {
    }
    
    @IBOutlet weak var ac_go: UIButton!
}
