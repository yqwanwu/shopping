//
//  ReturnInfoVC.swift
//  Shopping_W
//
//  Created by wanwu on 2018/4/16.
//  Copyright © 2018年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class ReturnInfoVC: BaseViewController {
    @IBOutlet weak var companyTF: CheckTextFiled!
    @IBOutlet weak var orderTF: CheckTextFiled!
    var orderModel = ReturnedModel()
    
    var expresses = [ExpressInfoModel]()
    var selectModel = ExpressInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestData()
    }
    
    func requestData() {
        MBProgressHUD.show()
        NetworkManager.requestPageInfoModel(params: ["method":"getExpressList", "fOrderid":orderModel.fOrderid, "currentPage":1, "pageSize":2000]).setSuccessAction { (bm: BaseModel<ExpressInfoModel>) in
            MBProgressHUD.hideHUD()
            bm.whenSuccess {
                self.expresses = bm.pageInfo!.list!
            }
        }
    }
    
    @IBAction func ac_select(_ sender: Any) {
        
        let vc = UIStoryboard(name: "AddCardVC", bundle: Bundle.main).instantiateViewController(withIdentifier: RegionSelectVC.getNameString()) as! RegionSelectVC
        vc.models = expresses.map({ $0.F_Name })
        vc.selectAction = { idx in
            self.companyTF.text = vc.models[idx]
            self.selectModel = self.expresses[idx]
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ac_ok(_ sender: Any) {
        if !companyTF.check() {
            return
        }
        
        if !orderTF.check() {
            return
        }
        
        /**
         method    string    buyersendback    无
         rid    string    前台获取    退换货单ID
         oid    string    前台获取    订单ID
         eid    string    前台获取    快递公司ID
         ecode    string    前台获取    快递单号
            */
        MBProgressHUD.show()
        NetworkManager.requestTModel(params: ["method":"buyersendback", "rid":orderModel.fReturnid, "oid":orderModel.fOrderid, "eid":selectModel.F_ExpressID, "ecode":selectModel.F_Code]).setSuccessAction { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hideHUD()
            bm.whenSuccess {
                MBProgressHUD.show(successText: "已提交")
                ReturnedVC.needReload = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
