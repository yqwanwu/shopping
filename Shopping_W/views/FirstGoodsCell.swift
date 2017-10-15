//
//  FirstGoodsCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/11.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class FirstGoodsCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var specsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var tagBtn: UIButton!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var oldPriceLabel: UILabel!
    
    var model: GoodsModel? {
        didSet {
            let attrStr = NSMutableAttributedString(string: "", attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
            oldPriceLabel.attributedText = attrStr
            if let m = model {
                titleLabel.text = m.fGoodsname
                specsLabel.text = m.fSummary
                priceLabel.text = "¥\(m.fSalesprice.moneyValue())"
//                tagBtn.setTitle(m.fTags, for: .normal)
                ImgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl))
//                tagBtn.setTitle("推荐", for: .normal)
            }
        }
    }
    
    var promotionModel: PromotionModel? {
        didSet {
            let attrStr = NSMutableAttributedString(string: "", attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
            oldPriceLabel.attributedText = attrStr
            if let m = promotionModel {
                titleLabel.text = m.fGoodsname
                specsLabel.text = m.fSummary
                priceLabel.text = "¥\(m.fSalesprice.moneyValue())"
                
                ImgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl))
                
                switch m.fType {
                case 1:
//                    tagBtn.setTitle("团购", for: .normal)
                    let attrStr = NSMutableAttributedString(string: "¥" + m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    oldPriceLabel.attributedText = attrStr
                    priceLabel.text = "¥\(m.fPromotionprice.moneyValue())"
                case 2:
//                    tagBtn.setTitle("秒杀", for: .normal)
                    let attrStr = NSMutableAttributedString(string: "¥" + m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    oldPriceLabel.attributedText = attrStr
                    priceLabel.text = "¥\(m.fPromotionprice.moneyValue())"
//                case 3:
//                    tagBtn.setTitle("满\(Int(m.fPrice))-\(Int(m.fDeduction))", for: .normal)
//                case 4:
//                    tagBtn.setTitle("赠", for: .normal)
//                case 5:
//                    tagBtn.setTitle("\(m.fMintegral)倍积分", for: .normal)
                case 6:
//                    tagBtn.setTitle("\(m.fDiscount)折", for: .normal)
                    let attrStr = NSMutableAttributedString(string: "¥" + m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    oldPriceLabel.attributedText = attrStr
                    priceLabel.text = "¥\(m.fPromotionprice.moneyValue())"
                default:
                    break
                }
            }
        }
    }
    
    func dealType(type: Int) {
        
    }

    //height 155
    override func awakeFromNib() {
        super.awakeFromNib()
//        tagBtn.layer.cornerRadius = CustomValue.btnCornerRadius
//        tagBtn.titleLabel?.lineBreakMode = .byTruncatingTail
//        tagBtn.layer.borderColor = CustomValue.common_red.cgColor
//        tagBtn.layer.borderWidth = 0.5
//        tagBtn.titleLabel?.adjustsFontSizeToFitWidth = true
    }

}
