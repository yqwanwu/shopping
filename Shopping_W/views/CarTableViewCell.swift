//
//  CarTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import SDWebImage
import UIKit

class CarTableViewCell: CustomTableViewCell {
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countBtn: CalculateBtn!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goodsimg: UIImageView!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? CarModel {
                priceLabel.text = m.F_Price.moneyValue()
                countBtn.numberText.text = "\(m.F_Count)"
                numberLabel.text = ""
                numberNameLabel.text = m.F_ExString
                titleLabel.text = m.F_GoodsName
                goodsimg.sd_setImage(with: URL.encodeUrl(string: m.F_GoodImg))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goodsimg.layer.borderWidth = 1
        goodsimg.layer.borderColor = UIColor.gray.cgColor
        goodsimg.layer.cornerRadius = 10
        
        countBtn.changeAction = { [unowned self] _ in
            if let m = self.model as? CarModel {
                m.F_Count = Int(self.countBtn.numberText.text ?? "") ?? 1
                m.updateCount()
            }
        }
    }
    @IBAction func ac_select(_ sender: UIButton) {
        if let m = model as? CarModel {
            m.selectedAction?()
            m.isSelected = !m.isSelected
            sender.isSelected = m.isSelected
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
