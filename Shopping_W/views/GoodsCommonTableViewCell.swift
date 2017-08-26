//
//  GoodsCommonTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class GoodsCommonTableViewCell: CustomTableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var commonLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            commonLabel.isHidden = false
            countLabel.isHidden = true
            
            if let m = model as? GoodsModel {
                oldPriceLabel.isHidden = true
                nameLabel.text = m.fGoodsname
                currentPriceLabel.text = m.fSalesprice.moneyValue()
                imgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl), placeholderImage: #imageLiteral(resourceName: "placehoder"))
                commonLabel.isHidden = false
                let attrStr = NSMutableAttributedString(string: "12312", attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                oldPriceLabel.attributedText = attrStr
                descLabel.text = m.fSummary
            } else if let m = model as? PromotionModel {
                nameLabel.text = m.fGoodsname
                imgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl), placeholderImage: #imageLiteral(resourceName: "placehoder"))
                descLabel.text = m.fSummary
                currentPriceLabel.text = m.fSalesprice.moneyValue()
                if m.type == .promotions {
//                    let attrStr = NSMutableAttributedString(string: "满意100减20", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
//                    oldPriceLabel.attributedText = attrStr
//                    commonLabel.isHidden = true
                    
                    if m.fType == 6 {
                        let attrStr1 = NSMutableAttributedString(string: "¥" + m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                        countLabel.attributedText = attrStr1
                        countLabel.isHidden = false
                        currentPriceLabel.text = "¥" + m.fPromotionprice.moneyValue()
                    }
                    self.dealType()
                } else {
                    let attrStr = NSMutableAttributedString(string: "¥" + m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    oldPriceLabel.attributedText = attrStr
                    //促销类别 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
                    if m.type == .group {
                        currentPriceLabel.text = "¥" + m.fPromotionprice.moneyValue()
                        let htmlStr = CustomValue.htmlHeader + "<p>" +
                            "<span style='color: #fdc249'>10件</span>" +
                            "<span style='color: black'>成团，还差</span>" +
                            "<span style='color: #fdc249'>3件</span>" +
                            "</p>" + CustomValue.htmlFooter
                        let htmlData = htmlStr.data(using: .utf8)
                        let htmlattr = try! NSAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
//                        commonLabel.attributedText = htmlattr
                    } else if m.type == .seckill {
                        commonLabel.isHidden = true
                    }
                }
            } else if let m = model as? SecKillExtModel {
                commonLabel.isHidden = true
                nameLabel.text = m.fGoodsname
                let desc = Tools.stringIsNotBlank(text: m.fSummary) ? m.fSummary : ""
                descLabel.text = desc
                imgView.sd_setImage(with: URL.encodeUrl(string: m.fPicurl))
                currentPriceLabel.text = m.fSaleprice.moneyValue()
            }
        }
    }

    func dealType() {
        if let m = model as? PromotionModel {
            commonLabel.isHidden = true
            switch m.fType {
            case 3:
                let attrStr = NSMutableAttributedString(string: "满\(Int(m.fPrice))-\(Int(m.fDeduction))", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                oldPriceLabel.attributedText = attrStr
            case 4:
                let attrStr = NSMutableAttributedString(string: "赠", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                oldPriceLabel.attributedText = attrStr
            case 5:
                let attrStr = NSMutableAttributedString(string: "\(m.fMintegral)倍积分", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                oldPriceLabel.attributedText = attrStr
            case 6:
                let attrStr = NSMutableAttributedString(string: "\(m.fDiscount)折", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                oldPriceLabel.attributedText = attrStr
                
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
