//
//  EvaluateCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class EvaluateCell: CustomTableViewCell {
    @IBOutlet weak var starView: StarMarkView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? EvaluationModel {
                starView.score = CGFloat(m.fStar)
                nameLabel.text = m.fNickname
                detailLabel.text = m.fContent
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        starView.sadImg = #imageLiteral(resourceName: "p4.6.1.1-评价-灰.png")
        starView.likeImg = #imageLiteral(resourceName: "p4.6.1.1-评价-红.png")
        starView.margin = 5
        starView.isPanGestureEnable = false
        starView.isTapGestureEnable = false
    }
    
}
