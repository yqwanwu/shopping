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
    @IBOutlet weak var tagBtn: UIButton!
    @IBOutlet weak var ImgView: UIImageView!
    
    var model: GoodsModel? {
        didSet {
            if let m = model {
                titleLabel.text = m.fGoodsname
                specsLabel.text = m.fNo
                priceLabel.text = "¥\(m.fSalesprice)"
                tagBtn.setTitle(m.fTags, for: .normal)
                ImgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl))
            }
        }
    }

    //height 155
    override func awakeFromNib() {
        super.awakeFromNib()
        tagBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        tagBtn.titleLabel?.lineBreakMode = .byTruncatingTail
    }

}
