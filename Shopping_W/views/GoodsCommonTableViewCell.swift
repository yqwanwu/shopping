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
                
            } else if let m = model as? PromotionModel {
                nameLabel.text = m.fGoodsname
//                imgView.sd_setImage(with: URL.encodeUrl(string: m.f), placeholderImage: <#T##UIImage?#>)
                descLabel.text = m.fSummary
                currentPriceLabel.text = m.fPromotionprice.moneyValue()
                if m.type == .promotions {
                    let attrStr = NSMutableAttributedString(string: "满意100减20", attributes: [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "fdc249"), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)])
                    oldPriceLabel.attributedText = attrStr
                    commonLabel.isHidden = true
                } else {
                    let attrStr = NSMutableAttributedString(string: m.fSalesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    oldPriceLabel.attributedText = attrStr
                    
                    if m.type == .group {
                        let htmlStr = CustomValue.htmlHeader + "<p>" +
                            "<span style='color: #fdc249'>10件</span>" +
                            "<span style='color: black'>成团，还差</span>" +
                            "<span style='color: #fdc249'>3件</span>" +
                            "</p>" + CustomValue.htmlFooter
                        let htmlData = htmlStr.data(using: .utf8)
                        let htmlattr = try! NSAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                        commonLabel.attributedText = htmlattr
                    } else if m.type == .seckill {
                        commonLabel.isHidden = true
                    }
                }
            } 
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
