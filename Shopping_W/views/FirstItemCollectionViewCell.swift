//
//  FirstItemCollectionViewCell.swift
//  Shopping_W
//
//  Created by 10.11.5 on 2017/8/19.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class FirstItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var titleLabel1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView1.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imgView1.layer.cornerRadius = imgView1.frame.width / 2
    }
    
}
