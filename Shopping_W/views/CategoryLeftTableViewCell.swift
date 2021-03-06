//
//  CategoryLeftTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/23.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CategoryLeftTableViewCell: CustomTableViewCell {

    @IBOutlet weak var redVIew: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let textColor = UIColor.hexStringToColor(hexString: "888888")
    static let bkColor = UIColor.hexStringToColor(hexString: "efefef")
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? CategoryModel {
                self.titleLabel.text = m.fCategoryname
                self.redVIew.isHidden = !m.isSelected
                self.titleLabel.textColor = m.isSelected ? CustomValue.common_red : CategoryLeftTableViewCell.textColor
                self.contentView.backgroundColor = m.isSelected ? CategoryVC.bkColor : UIColor.white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = CategoryLeftTableViewCell.bkColor
        redVIew.isHidden = true
        titleLabel.textColor = CategoryLeftTableViewCell.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
