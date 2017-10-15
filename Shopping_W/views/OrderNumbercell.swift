//
//  OrderNumbercell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/10/15.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class OrderNumbercell: OrerListCell {
    @IBOutlet weak var orderNumberLabel: UILabel!
    var orderAction: (() -> Void)?
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? OrderModel {
                orderNumberLabel.text = "订单编号: \(m.fOrderid)"
            }
        }
    }
    
    @IBAction func ac_order(_ sender: Any) {
        orderAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
