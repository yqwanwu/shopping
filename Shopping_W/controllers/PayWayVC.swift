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
    
    var orderModel: OrderModel!
    
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
        /*
         method	string	apiPayforAPP	无
         fOrderid	string	前台获取	订单ID用','串联
         fType	string	前台获取	0订单 1充值
         fAmount	string	前台获取	付款金额
         fPaytype	string	前台获取	1银行卡 2支付宝 3微信
         isUseIntegral	string	前台获取	是否使用积分0否1是
         useIntegral	string	前台获取	使用积分数量
         isUseUserAmount	string	前台获取	是否使用余额0否1是
         useUserAmount	string	前台获取	使用余额
 */
        let params = ["method":"apiPayforAPP", "fOrderid":orderModel.fOrderid, "fType":"0", "fAmount":orderModel.fSaleamount, "fPaytype":"2", "isUseIntegral":"0", "useIntegral":"0", "isUseUserAmount":"0", "useUserAmount":"0"] as [String : Any]
        
//        let params = ["method":"apiPayforAPP", "fOrderid":"3725114078400241", "fType":"0", "fAmount":0.01, "fPaytype":"2", "isUseIntegral":"0", "useIntegral":"0", "isUseUserAmount":"0", "useUserAmount":"0"] as [String : Any]
        
        NetworkManager.JsonPostRequest(params: params, success: { (json) in
            if json["code"].stringValue == "0" {
                let str = json["message"].stringValue
                AlipaySDK.defaultService().payOrder(str, fromScheme: "tjgy_ios") { (dic) in
                    print(dic)
                }
            }
        }) { (err) in
            
        }
        
        
//        self.performSegue(withIdentifier: k_toPayResultVC, sender: self)
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
