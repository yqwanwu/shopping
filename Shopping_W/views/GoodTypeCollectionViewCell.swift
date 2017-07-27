//
//  GoodTypeCollectionViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class GoodTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btn: UIButton!
    
    var clickAction: BLANK_CLOSURE?
    
    
    var model: GoodsExtTypeModel! {
        didSet {
            switch model.state {
            case .disable:
                btn.layer.borderColor = UIColor.hexStringToColor(hexString: "dedede").cgColor
                btn.setTitleColor(UIColor.hexStringToColor(hexString: "dedede"), for: .normal)
                btn.layer.borderWidth = 1
                self.btn.isEnabled = false
            case .enable:
                btn.layer.borderColor = UIColor.black.cgColor
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.layer.borderWidth = 1
            case .selected:
                btn.layer.borderColor = UIColor.hexStringToColor(hexString: "fdc249").cgColor
                btn.setTitleColor(UIColor.hexStringToColor(hexString: "fdc249"), for: .normal)
                btn.layer.borderWidth = 1
            default:
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.layer.borderWidth = 0
            }
        }
    }
    
    @IBAction func ac_select(_ sender: Any) {
        clickAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.contentMode = .center
        
        btn.setTitleColor(CustomValue.common_red, for: .highlighted)
        btn.layer.cornerRadius = 4
        btn.isEnabled = false
    }

}
