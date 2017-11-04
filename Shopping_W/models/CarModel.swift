//
//  CarModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import Realm
import RealmSwift

typealias BLANK_CLOSURE = () -> Void


class CarListModel: CustomTableViewCellItem {
    var goodList = [CarModel]()
    var fShopid = 0
    var fShopName = ""
    var isListSelected = false
    
    func setSelected() {
        for item in goodList {
            item.isSelected = isListSelected
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object == nil {
            return false
        }
        
        if let o = object as? CarListModel {
            return self.fShopid == o.fShopid
        }
        
        return false
    }
    
    override var hash: Int {
        return fShopid;
        
    }
}


class CarModel: CustomTableViewCellItem {
    weak var carList: CarListModel?
    
    var fShopid = 0
    var fShopName = ""
    
    var fGoodsummary: String?
    var fBuycount = 0
    var fSalecount = 0
    var fStock = 0
    var fFreegoodName = ""
    var fDeduction = 0.0//减额,type=3时使用,满F_Price减F_Deduction
    var fCount = 1 {//数量
        didSet {
            countAction?()
        }
    }
    var fType = 0//类型 0:普通 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    var fPurchasecount = 0//单人限购数量(type不为0时使用,修改数量时需要限制)
    var F_PState = 0//促销状态(type不为0时使用,判断此值为1时才能提交订单)
    var F_SaleState = 0//促销上架状态(type不为0时使用,判断此值为1时才能提交订单)
    var fState = 0//0:未上架 1:已上架(type为0需要判断)
    var F_IsDel = false//是否删除 0:否 1:是(type为0需要判断)
    var fPromotioncount = 0//促销总数量(type不为0时使用)
    var fPromotionprice = 0.0//活动价(团购,秒杀用)
    var fDiscount = 0.0//折扣,type=6时使用,最终价格为F_SalePrice*F_Discount
    var fSalesprice = 0.0//销售价(type为0表示销售价,不为0表示原价)
    var fExstring = ""//所选规格信息
    var fGoodsid = 0//商品ID
    var fGoodsname = ""//商品名称
    var F_UserAccountID = 0//用户ID
    var fIntegral = 0.0
    var fMIntegral = 0.0//多倍积分倍数,type=5时使用
    var fId = 0//购物车ID
    var fGoodimg = ""//商品图片
    var fPeid = 0//促销扩展信息ID
    var fGeid = 0//商品扩展信息ID
    var fPrice = 0.0//满额,type=3时使用,满F_Price减F_Deduction
    var fPromotionid = 0//促销ID
    
    var countAction: BLANK_CLOSURE?
    var isSelected = false {
        didSet {
            selectedAction?()
        }
    }
    var selectedAction: BLANK_CLOSURE?
    
    static var items = [CarModel]()
    
    func saveToDB() {
        let obj = CarRealmModel()
        let m = Mirror(reflecting: obj)
        for c in m.children {
            obj.setValue(self.value(forKey: c.label!), forKey: c.label!)
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(obj, update: true)
        }
    }
    
    static func readFromDB() -> [CarModel] {
        let realm = try! Realm()
        let list = realm.objects(CarRealmModel.self)
    
        let m = Mirror(reflecting: CarRealmModel())
        var arr = [CarModel]()
        for obj in list {
            let car = CarModel()
            for c in m.children {
                car.setValue(obj.value(forKey: c.label!), forKey: c.label!)
            }
            arr.append(car)
        }
        return arr
    }
    
    static func readTreeDataFromDB() -> [CarListModel] {
        var ids = Set<Int>()
        let arr = readFromDB()
        for car in arr {
            ids.insert(car.fShopid)
        }
        var carList = [CarListModel]()
        for id in ids {
            let model = CarListModel()
            let list = arr.filter({ $0.fShopid == id })
            model.fShopid = id
            model.goodList = list
            model.fShopName = list.first!.fShopName
            carList.append(model)
        }
        return carList
    }
    
    func deleteFromDB() {
        let realm = try! Realm()
        let list = realm.objects(CarRealmModel.self).filter("fGoodsid=%@ and fPromotionid=%@", fGoodsid, fPromotionid)
        try! realm.write {
            if let obj = list.first {
                realm.delete(obj)
            }
        }
    }
    
    static func addToServer() {
        for car in self.readFromDB() {
            let params = ["method":"apiaddtoshopcart", "fGoodsid":car.fGoodsid, "fCount":car.fCount, "fGeid":car.fGeid, "fPromotionid":car.fPromotionid == 0 ? "" : "\(car.fPromotionid)"] as [String : Any]
            NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
                bm.whenSuccess {
                    CarVC.needsReload = true
                }
            }) { (err) in
                
            }
        }
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    
    static func requestList() {
        NetworkManager.requestListModel(params: ["method":"apishopcartlist"]).setSuccessAction { (bm: BaseModel<CarModel>) in
            if let list = bm.list {
                CarModel.items = list
            }
        }
    }
    
    ///传入id判断原来是否已有，不传就直接去items的数量
    static func getCount(carId: Int? = nil) -> Int {
        if let id = carId, carId != 0 {
            for item in items {
                if item.fId == id {
                    return items.count
                }
            }
            
            return items.count + 1
        } else {
            return items.count
        }
    }
    
    /*
     method	string	apiupdateshopcartcount	无
     fId	int	自行获取	购物车ID
     fCout	int	自行获取	商品数量
     */
    func updateCount() {
        NetworkManager.requestModel(params: ["method":"apiupdateshopcartcount", "fId":self.fId, "fCout":self.fCount], success: { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                
            }
        }) { (err) in
            
        }
    }
    
    func delete(complete: BLANK_CLOSURE?) {
        NetworkManager.requestModel(params: ["method":"apidelshopcart", "fId":self.fId], success: { (bm: BaseModel<CodeModel>) in
            CarModel.items = CarModel.items.filter({ $0.fId != self.fId })
            bm.whenSuccess {
                complete?()
            }
        }) { (err) in
            MBProgressHUD.show(errorText: "请求失败")
        }
    }
}


class CarRealmModel: Object {
    dynamic var fShopid = 0
    dynamic var fShopName = ""
    
    dynamic var fGoodsummary: String?
    
    dynamic var fBuycount = 0
    dynamic var fSalecount = 0
    dynamic var fStock = 0
    dynamic var fFreegoodName = ""
    dynamic var fDeduction = 0.0//减额,type=3时使用,满F_Price减F_Deduction
    dynamic var fCount = 1
    dynamic var fType = 0//类型 0:普通 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    dynamic var fPurchasecount = 0//单人限购数量(type不为0时使用,修改数量时需要限制)
    dynamic var F_PState = 0//促销状态(type不为0时使用,判断此值为1时才能提交订单)
    dynamic var F_SaleState = 0//促销上架状态(type不为0时使用,判断此值为1时才能提交订单)
    dynamic var fState = false//0:未上架 1:已上架(type为0需要判断)
    dynamic var F_IsDel = false//是否删除 0:否 1:是(type为0需要判断)
    dynamic var fPromotioncount = 0//促销总数量(type不为0时使用)
    dynamic var fPromotionprice = 0.0//活动价(团购,秒杀用)
    dynamic var fDiscount = 0.0//折扣,type=6时使用,最终价格为F_SalePrice*F_Discount
    dynamic var fSalesprice = 0.0//销售价(type为0表示销售价,不为0表示原价)
    dynamic var fExstring = ""//所选规格信息
    dynamic var fGoodsid = 0//商品ID
    dynamic var fGoodsname = ""//商品名称
    dynamic var F_UserAccountID = 0//用户ID
    dynamic var fIntegral = 0.0
    dynamic var fMIntegral = 0//多倍积分倍数,type=5时使用
    dynamic var fId = 0//购物车ID
    dynamic var fGoodimg = ""//商品图片
    dynamic var fPeid = 0//促销扩展信息ID
    dynamic var fGeid = 0//商品扩展信息ID
    dynamic var fPrice = 0.0//满额,type=3时使用,满F_Price减F_Deduction
    dynamic var fPromotionid = 0//促销ID
    
    override static func primaryKey() -> String? {
        return "fGeid"
    }
}
