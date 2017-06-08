//
//  PayWayVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class PayWayVC: BaseViewController, UITableViewDelegate {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: CustomTableView!
    
    let k_toPayResultVC = "toPayResultVC"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        
        let p = payWayModel().build(text: "支付宝支付").build(cellClass: PayByThird.self).build(heightForRow: 50).build(isFromStoryBord: true)
        p.img = #imageLiteral(resourceName: "支付宝支付")
        let p1 = payWayModel().build(text: "微信支付").build(cellClass: PayByThird.self).build(heightForRow: 50).build(isFromStoryBord: true)
        p1.img = #imageLiteral(resourceName: "微信支付")
        let p2 = payWayModel().build(text: "银行卡支付").build(cellClass: PayByThird.self).build(heightForRow: 50).build(isFromStoryBord: true)
        p2.img = #imageLiteral(resourceName: "银行卡支付")
        let p3 = payWayModel().build(cellClass: PayByBalance.self).build(heightForRow: 50).build(isFromStoryBord: true)
        p3.totalPrice = "¥123"
        
        tableView.dataArray = [[p, p1, p2], [p3]]
        tableView.sectionHeaderHeight = 8
    }
    
    @IBAction func ac_cancle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ac_ok(_ sender: Any) {
        self.performSegue(withIdentifier: k_toPayResultVC, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PayResultVC {
            let b = self.navigationController?.viewControllers.count ?? 0 >= 4
            vc.isSuccess = b
        }
    }

}

class payWayModel: CustomTableViewCellItem {
    var isSelected = false
    var img: UIImage?
    var totalPrice = ""
}

class PayByThird: CustomTableViewCell {
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let  m = model as? payWayModel {
                selectImg.image = m.isSelected ? #imageLiteral(resourceName: "v") : #imageLiteral(resourceName: "o")
                icon.image = m.img
                nameLabel.text = m.text
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectImg.image = isSelected ? #imageLiteral(resourceName: "v") : #imageLiteral(resourceName: "o")
            if let  m = model as? payWayModel {
                m.isSelected = self.isSelected
            
            }
        }
    }

}

class PayByBalance: CustomTableViewCell {
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let  m = model as? payWayModel {
                selectImg.image = m.isSelected ? #imageLiteral(resourceName: "v") : #imageLiteral(resourceName: "o")
                totalPriceLabel.text = m.totalPrice
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectImg.image = isSelected ? #imageLiteral(resourceName: "v") : #imageLiteral(resourceName: "o")
            if let  m = model as? payWayModel {
                m.isSelected = self.isSelected
            }
        }
    }
    
}
