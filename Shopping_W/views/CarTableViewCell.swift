//
//  CarTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import SDWebImage
import UIKit
import MBProgressHUD

class CarTableViewCell: CustomTableViewCell {
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countBtn: CalculateBtn!
    @IBOutlet weak var extLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var numberNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var goodsimg: UIImageView!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? CarModel {
                oldPriceLabel.isHidden = true
                priceLabel.text = m.fSalesprice.moneyValue()
                countBtn.numberText.text = "\(m.fCount)"
                countBtn.subtractBtn.isEnabled = m.fCount > 1
                
                let s = m.fGoodsummary ?? ""
                numberNameLabel.text = "\(s)"
                
                extLabel.text = m.fExstring
                titleLabel.text = m.fGoodsname
                goodsimg.sd_setImage(with: URL.encodeUrl(string: m.fGoodimg))
                chooseBtn.isSelected = m.isSelected
                typeLabel.isHidden = false
                switch m.fType {
                case 1:
                    typeLabel.text = "团购"
                    priceLabel.text = m.fPromotionprice.moneyValue()
                    let attrStr = NSMutableAttributedString(string: "¥" + m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    oldPriceLabel.attributedText = attrStr
                    oldPriceLabel.isHidden = false
                case 2:
                    typeLabel.text = "秒杀"
                    priceLabel.text = m.fPromotionprice.moneyValue()
                    let attrStr = NSMutableAttributedString(string: "¥" + m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    oldPriceLabel.attributedText = attrStr
                    oldPriceLabel.isHidden = false
                case 3:
                    let attrStr = NSMutableAttributedString(string: "满\(Int(m.fPrice))-\(Int(m.fDeduction))", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                    typeLabel.attributedText = attrStr
                case 4:
                    let attrStr = NSMutableAttributedString(string: "赠", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                    typeLabel.attributedText = attrStr
                case 5:
                    let attrStr = NSMutableAttributedString(string: "\(m.fMIntegral)倍积分", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                    typeLabel.attributedText = attrStr
                case 6:
                    let attrStr = NSMutableAttributedString(string: "\(m.fDiscount)折", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                    typeLabel.attributedText = attrStr
                    
                default:
                    typeLabel.isHidden = true
                    break
                }
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
            var count = Int(self.countBtn.numberText.text ?? "") ?? 1
            
            count = count > m.fStock ? m.fStock : count
            
            m.fCount = count
            if PersonMdel.isLogined() {
                m.updateCount()
            } else {
                m.saveToDB()
            }
        }
    }
    
    @IBAction func ac_select(_ sender: UIButton) {
        var flag = false
        
        if let m = model as? CarModel {
            if m.fState == 0 {
                MBProgressHUD.show(errorText: "商品已不在销售状态")
                flag = true
            }
            if m.fType == 0 {
                if m.fCount > m.fStock {
                    MBProgressHUD.show(errorText: "库存不足")
                    flag = true
                }
            } else {
                if m.fCount + m.fBuycount > m.fPurchasecount {
                    MBProgressHUD.show(errorText: "超过限购数量")
                    flag = true
                }
            }
            if flag {
                m.isSelected = false
                sender.isSelected = false
                return
            }
            
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
