//
//  OrerListCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/5.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class OrerListCell: CustomTableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var logisticsBtn: UIButton!
    @IBOutlet weak var reciveBtn: UIButton!
    @IBOutlet weak var reciveWidth: NSLayoutConstraint!
    
    var logisticsAction: (() -> Void)?
    var reciveAction: (() -> Void)?
    
    override var model: CustomTableViewCellItem? {
        didSet {
            logisticsBtn.isHidden = false
            if let m = model as? OrderModel {
                logisticsBtn.isHidden = m.type != .recive
                reciveWidth.constant = 80
                switch m.type {
                case .pay:
                    reciveBtn.setTitle("立即付款", for: .normal)
                case .send:
                    reciveBtn.setTitle("提醒卖家发货", for: .normal)
                    reciveWidth.constant = 110
                case .evaluate:
                    reciveBtn.setTitle("评价", for: .normal)
                case .alreadyEvaluate:
                    reciveBtn.setTitle("追加评价", for: .normal)
                case .myCollection:
                    reciveBtn.setTitle("查看", for: .normal)
                    reciveBtn.snp.updateConstraints({ (make) in
                        let r = (UIScreen.main.bounds.width - 130 - 80) / 2
                        make.right.equalTo(self.contentView).offset(-r)
                    })
                case .myEvaluate:
                    reciveBtn.layer.borderColor = UIColor.hexStringToColor(hexString: "888888").cgColor
                    reciveBtn.layer.borderWidth = 1
                    reciveBtn.backgroundColor = UIColor.clear
                    reciveBtn.setTitleColor(UIColor.hexStringToColor(hexString: "888888"), for: .normal)
                    logisticsBtn.isHidden = false
                    logisticsBtn.backgroundColor = CustomValue.common_red
                    logisticsBtn.setTitle("查看", for: .normal)
                    logisticsBtn.setTitleColor(UIColor.white, for: .normal)
                    logisticsBtn.layer.borderWidth = 0
                    reciveBtn.setTitle("重新评价", for: .normal)
                    
                    logisticsBtn.snp.updateConstraints({ (make) in
                        make.width.equalTo(50)
                    })
                    reciveBtn.snp.remakeConstraints({ (make) in
                        make.height.equalTo(30)
                        make.width.equalTo(80)
                        make.top.equalTo(priceLabel.snp.bottom).offset(10)
                        make.left.equalTo(logisticsBtn.snp.right).offset(15)
                    })
                    
                default:
                    break
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        logisticsBtn.layer.borderColor = UIColor.hexStringToColor(hexString: "888888").cgColor
        logisticsBtn.layer.borderWidth = 1
        logisticsBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        reciveBtn.layer.cornerRadius = CustomValue.btnCornerRadius
    }

    @IBAction func ac_logistics(_ sender: UIButton) {
        logisticsAction?()
    }

    @IBAction func ac_recive(_ sender: UIButton) {
        reciveAction?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
