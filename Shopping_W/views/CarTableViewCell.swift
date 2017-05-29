//
//  CarTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CarTableViewCell: CustomTableViewCell {
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countBtn: CalculateBtn!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goodsimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goodsimg.layer.borderWidth = 1
        goodsimg.layer.borderColor = UIColor.gray.cgColor
        goodsimg.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
