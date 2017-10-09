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
    
    let customLabel: UILabel = {
        let l = UILabel(frame: CGRect.zero)
        l.textAlignment = .center
        l.textColor = CustomValue.common_red
        l.text = "换货中..."
        l.isHidden = true
        return l
    } ()
    
    override var model: CustomTableViewCellItem? {
        didSet {
            logisticsBtn.isHidden = false
            customLabel.isHidden = true
            if let m = model as? OrderModel {
                logisticsBtn.isHidden = m.type != .recive
                reciveWidth.constant = 80
                logisticsBtn.setTitle("查看物流", for: .normal)
                switch m.type {
                case .pay:
                    logisticsBtn.isHidden = false
                    logisticsBtn.setTitle("取消订单", for: .normal)
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
                        let r = (UIScreen.main.bounds.width - 116 - 80) / 2
                        make.right.equalTo(self.contentView).offset(-r)
                    })
                case .cookies:
                    reciveBtn.setTitle("查看", for: .normal)
                    reciveBtn.snp.updateConstraints({ (make) in
                        let r = (UIScreen.main.bounds.width - 116 - 80)
                        make.left.equalTo(self.imgView).offset(r)
                    })
                case .returned:
                    reciveBtn.setTitle("申请退换货", for: .normal)
                    reciveWidth.constant = 100
                    reciveBtn.isHidden = false
                case .returning:
                    reciveWidth.constant = 100
                    customLabel.isHidden = false
                    reciveBtn.isHidden = true
                    break
                default:
                    break
                }
                let ex = m.orderEx.first!
                self.imgView.sd_setImage(with: URL.encodeUrl(string: ex.fUrl))
                self.titleLabel.text = ex.fGoodsname
                self.priceLabel.text = m.fSaleamount.moneyValue()
                self.countLabel.text = "\(ex.fSpecifications)  x\(ex.fCount)"
            } else if let m = model as? CarModel {
                self.imgView.sd_setImage(with: URL.encodeUrl(string: m.fGoodimg))
                self.titleLabel.text = m.fGoodsname
                self.priceLabel.text = m.fSalesprice.moneyValue()
                self.countLabel.text = "\(m.fExstring)  x\(m.fCount)"
                
            } else if let m = model as? ReturnedModel {
                //退货状态 null 显示申请换货按钮  0待审核 1待回寄 2待发货\待退款 3待收货 4完成
                reciveWidth.constant = 100
                customLabel.isHidden = true
                logisticsBtn.isHidden = true
                reciveBtn.isHidden = false
                switch m.fState {
                case -1:
                    reciveBtn.setTitle("申请退换货", for: .normal)
                case 0:
                    reciveBtn.setTitle("待审核", for: .normal)
                case 1:
                    reciveBtn.setTitle("待回寄", for: .normal)
                case 2:
                    reciveBtn.setTitle("待退款", for: .normal)
                case 3:
                    reciveBtn.setTitle("待收货", for: .normal)
                case 4:
                    reciveBtn.setTitle("完成", for: .normal)
                default:
                    customLabel.isHidden = false
                    reciveBtn.isHidden = true
                    break
                }
                
                self.imgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl))
                self.titleLabel.text = m.fGoodsname
                self.priceLabel.text = m.fSaleamount.moneyValue()
                self.countLabel.text = "\(m.F_Specifications)  x\(m.fCount)"
            } else if let m = model as? CollectionModel {
                self.imgView.sd_setImage(with: URL.encodeUrl(string: m.F_PicUrl))
                self.titleLabel.text = m.F_GoodsName
                self.priceLabel.text = m.F_salesprice.moneyValue()
                customLabel.isHidden = false
                switch m.F_Type {
                case 1:
                    self.countLabel.text = "团购"
                    let attrStr = NSMutableAttributedString(string: "¥" + m.F_salesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
                    customLabel.attributedText = attrStr
                    priceLabel.text = "¥\(m.F_PromotionPrice.moneyValue())"
                case 2:
                    self.customLabel.text = "秒杀"
                case 3:
                    customLabel.text = "满\(Int(m.F_Price))-\(Int(m.F_Deduction))"
                case 4:
                    customLabel.text = "赠"
                case 5:
                    customLabel.text = "\(m.F_MIntegral)倍积分"
                    
                case 6:
                    customLabel.text = "\(m.F_Discount)折"
                    let attrStr = NSMutableAttributedString(string: "¥" + m.F_salesprice.moneyValue(), attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
//                    oldPriceLabel.attributedText = attrStr
                    priceLabel.text = "¥\(m.F_PromotionPrice.moneyValue())"
                default:
                    break
                }
            } else if let m = model as? MyEvaluationModelItem {
                //TODO: 样式不一样
                imgView.sd_setImage(with: URL.encodeUrl(string: m.fUrl))
                titleLabel.text = m.fGoodsname
                priceLabel.text = "" //"¥\(m.f.moneyValue())"
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

            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        logisticsBtn.layer.borderColor = UIColor.hexStringToColor(hexString: "888888").cgColor
        logisticsBtn.layer.borderWidth = 1
        logisticsBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        reciveBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        
        contentView.addSubview(customLabel)
        
        customLabel.snp.makeConstraints { (make) in
            make.top.right.height.width.equalTo(reciveBtn)
        }
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
