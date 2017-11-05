//
//  OrderNumbercell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/10/15.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SnapKit

class OrderNumbercell: OrerListCell {
    @IBOutlet weak var orderNumberLabel: UILabel!
    var orderAction: (() -> Void)?
    @IBOutlet weak var typeLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? OrderModel {
                orderNumberLabel.text = "订单编号: \(m.fOrderid)"
                //var fState = 0// 0待付款 1已付款 2待发货 3已发货 4完成 5关闭
                switch m.fState {
                case 0:
                    typeLabel.text = "待付款"
                case 1:
                    typeLabel.text = "已付款"
                case 2:
                    typeLabel.text = "待发货"
                case 3:
                    typeLabel.text = "已发货"
                case 4:
                    typeLabel.text = "完成"
                case 5:
                    typeLabel.text = "关闭"
                default:
                    typeLabel.text = ""
                }
//
            }
        }
    }
    
    @IBAction func ac_order(_ sender: Any) {
        orderAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(imgView)
            make.left.equalTo(imgView.snp.right).offset(8)
        }
    }
    
}
