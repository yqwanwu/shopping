//
//  AddressTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/27.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddressTableViewCell: CustomTableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var add1Label: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var addressdetailLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? AddressModel {
                phoneLabel.text = m.fPhone
                nameLabel.text = m.fName
                let j = JSON(parseJSON: m.fAddressparams)
                add1Label.text = j["province"].stringValue + j["city"].stringValue + j["area"].stringValue
                addressdetailLabel.text = m.fAddress
                typeLabel.text = m.fTagname
                mailLabel.text = m.fPost
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func ac_modify(_ sender: UIButton) {
        if let m = model as? AddressModel {
            m.updateAcrion?()
        }
    }
}
