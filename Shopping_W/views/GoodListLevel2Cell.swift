//
//  GoodListLevel2Cell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SDWebImage

class GoodListLevel2Cell: CustomTableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? GoodsModel {
                imgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl))
                nameLabel.text = m.fGoodsname
                typeLabel.text = m.fNo
                priceLabel.text = m.fSalesprice.moneyValue()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

   
    
}
