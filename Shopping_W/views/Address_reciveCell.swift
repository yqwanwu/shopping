//
//  AddressCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/5.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SwiftyJSON

class Address_reciveCell: CustomTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? AddressModel, m.fAddressid != 0 {
                nameLabel.text = m.fName
                phoneLabel.text = m.fPhone
                let j = JSON(parseJSON: m.fAddressparams)

                address1Label.text = j["province"].stringValue + j["city"].stringValue + j["area"].stringValue
                
                address2Label.text = m.fAddress
                tagLabel.text = m.fTagname
                mailLabel.text = "邮编:" + m.fPost
                if m.fTagname == "" {
                    bottomHeight.constant = 15
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tagLabel.text = ""
    }
    
}
