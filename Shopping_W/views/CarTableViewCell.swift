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
                priceLabel.text = m.fSalesprice.moneyValue()
                countBtn.numberText.text = "\(m.fCount)"
                countBtn.subtractBtn.isEnabled = m.fCount > 1
                numberLabel.text = ""
                numberNameLabel.text = m.fExstring
                titleLabel.text = m.fGoodsname
                goodsimg.sd_setImage(with: URL.encodeUrl(string: m.fGoodimg))
                chooseBtn.isSelected = m.isSelected
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goodsimg.layer.borderWidth = 1
        goodsimg.layer.borderColor = UIColor.gray.cgColor
        goodsimg.layer.cornerRadius = 10
        
        countBtn.changeAction = { [unowned self] _ in
            if let _ = self.model as? CarModel {
                self.changeCount()
            }
        }
        
        countBtn.numberText.addTarget(self, action: #selector(CarTableViewCell.changeCount), for: .editingDidEnd)
    }
    
    func changeCount() {
        if let m = self.model as? CarModel {
            m.fCount = Int(self.countBtn.numberText.text ?? "") ?? 1
            if PersonMdel.isLogined() {
                m.updateCount()
            } else {
                m.saveToDB()
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
