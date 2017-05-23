//
//  SearchCollectionViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
    }
    
}
