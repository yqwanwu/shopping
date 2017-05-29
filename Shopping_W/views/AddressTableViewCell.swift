//
//  AddressTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/27.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var add1Label: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var addressdetailLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func ac_modify(_ sender: UIButton) {
    }
}
