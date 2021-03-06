//
//  PayWayVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class PayWayVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: CustomTableView!
    
    var orderModel = OrderModel()
    var preOrderModel: PreCreateOrder?
    var useIntegral = false
    var fIntegral = 0
    var totalPrice = ""
    
    let k_toPayResultVC = "toPayResultVC"
    let p = payWayModel().build(text: "支付宝支付").build(cellClass: PayByThird.self).build(heightForRow: 50).build(isFromStoryBord: true)
    let p1 = payWayModel().build(text: "微信支付").build(cellClass: PayByThird.self).build(heightForRow: 50).build(isFromStoryBord: true)
    let p2 = payWayModel().build(text: "银行卡支付").build(cellClass: PayByThird.self).build(heightForRow: 50).build(isFromStoryBord: true)
    let p3 = payWayModel().build(cellClass: PayByBalance.self).build(heightForRow: 50).build(isFromStoryBord: true)
    
    lazy var payArr: [payWayModel] = {
        return [self.p1, self.p, self.p2, self.p3]
    } ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalPriceLabel.text = totalPrice != "" ? totalPrice : (orderModel.fSaleamount + orderModel.fIntegralamount + orderModel.fPaidfreight + orderModel.fConcessions).moneyValue()

        tableView.delegate = self
        tableView.dataSource = self
        p.img = #imageLiteral(resourceName: "支付宝支付")
        p1.img = #imageLiteral(resourceName: "微信支付")
        p2.img = #imageLiteral(resourceName: "银行卡支付")
        
        p3.totalPrice = "¥123"
        
        tableView.dataArray = [[p1, p, p2], [p3]]
        
        for model in payArr {
            model.setupCellAction({ [unowned self] (idx) in
                for m in self.payArr {
                    m.isSelected = false
                }
                model.isSelected = true
                self.tableView.dataArray = [[self.p1, self.p, self.p2], [self.p3]]
                self.tableView.reloadData()
            })
        }
        
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
        var params = [String: Any]()
        MBProgressHUD.show()
        if let p = preOrderModel {
            params = ["method":"apiPayforAPP", "fOrderid":p.IDS, "fType":"0", "fAmount":p.payAmount, "isUseIntegral":useIntegral ? "1" : "0", "useIntegral":fIntegral, "isUseUserAmount":"0", "useUserAmount":"0"] as [String : Any]
        } else {
            params = ["method":"apiPayforAPP", "fOrderid":orderModel.fOrderid, "fType":"0", "fAmount":orderModel.fSaleamount, "fPaytype":"2", "isUseIntegral":useIntegral ? "1" : "0", "useIntegral":fIntegral, "isUseUserAmount":"0", "useUserAmount":"0"] as [String : Any]
        }
        
        if p.isSelected {
            params["fPaytype"] = "2"
            NetworkManager.JsonPostRequest(params: params, success: { (json) in
                if json["code"].stringValue == "0" {
                    let str = json["message"].stringValue
                    AlipaySDK.defaultService().payOrder(str, fromScheme: "tjgy_ios") { (dic) in
                        print(dic)
                        DispatchQueue.main.async {
                            MBProgressHUD.hideHUD()
                        }
                    }
                }
            }) { (err) in
                DispatchQueue.main.async {
                    MBProgressHUD.hideHUD()
                }
            }
        } else if p1.isSelected {
            params["fPaytype"] = "3"
            NetworkManager.JsonPostRequest(params: params, success: { (json) in
                if json["code"].stringValue == "0" {
                    let str = json["message"].stringValue
                    let j = JSON(parseJSON: str)
                    
                    let request = PayReq()
                    request.partnerId = j["mch_id"].stringValue
                    request.prepayId = j["prepay_id"].stringValue
                    request.nonceStr = j["nonce_str"].stringValue
                    request.timeStamp = j["timestamp"].uInt32Value
                    request.package = "Sign=WXPay"
                    request.sign = j["sign"].stringValue
                    DispatchQueue.main.async {
                        MBProgressHUD.hideHUD()
                    }
                    WXApi.send(request)
                }
            }) { (err) in
                DispatchQueue.main.async {
                    MBProgressHUD.hideHUD()
                }
            }
        }
        
        
//        self.performSegue(withIdentifier: k_toPayResultVC, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PayResultVC {
            let b = self.navigationController?.viewControllers.count ?? 0 >= 4
            vc.isSuccess = b
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.createDefaultCell(indexPath: indexPath)
        let model = self.tableView.dataArray[indexPath.section][indexPath.row] as! payWayModel
        if let c = cell as? PayByBalance {
            c.model = model
        } else if let c = cell as? PayByThird {
            c.model = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
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
    
//    override var isSelected: Bool {
//        didSet {
//            selectImg.image = isSelected ? #imageLiteral(resourceName: "v") : #imageLiteral(resourceName: "o")
//            if let  m = model as? payWayModel {
//                m.isSelected = self.isSelected
//            
//            }
//        }
//    }

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
    
//    override var isSelected: Bool {
//        didSet {
//            selectImg.image = isSelected ? #imageLiteral(resourceName: "v") : #imageLiteral(resourceName: "o")
//            if let  m = model as? payWayModel {
//                m.isSelected = self.isSelected
//            }
//        }
//    }
    
}
