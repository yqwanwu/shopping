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



class CarModel: CustomTableViewCellItem {
    
    var F_Deduction = 0.0//减额,type=3时使用,满F_Price减F_Deduction
    var F_Count = 1 {//数量
        didSet {
            countAction?()
        }
    }
    var F_Type = 0//类型 0:普通 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    var F_PurchaseCount = 0//单人限购数量(type不为0时使用,修改数量时需要限制)
    var F_PState = 0//促销状态(type不为0时使用,判断此值为1时才能提交订单)
    var F_SaleState = 0//促销上架状态(type不为0时使用,判断此值为1时才能提交订单)
    var F_State = false//0:未上架 1:已上架(type为0需要判断)
    var F_IsDel = false//是否删除 0:否 1:是(type为0需要判断)
    var F_PromotionCount = 0//促销总数量(type不为0时使用)
    var F_PromotionPrice = 0.0//活动价(团购,秒杀用)
    var F_Discount = 0.0//折扣,type=6时使用,最终价格为F_SalePrice*F_Discount
    var F_SalesPrice = 0.0//销售价(type为0表示销售价,不为0表示原价)
    var F_ExString = ""//所选规格信息
    var F_GoodsID = 0//商品ID
    var F_GoodsName = ""//商品名称
    var F_UserAccountID = 0//用户ID
    var F_MIntegral = 0.0//多倍积分倍数,type=5时使用
    var F_ID = 0//购物车ID
    var F_GoodImg = ""//商品图片
    var F_PEID = 0//促销扩展信息ID
    var F_GEID = 0//商品扩展信息ID
    var F_Price = 0.0//满额,type=3时使用,满F_Price减F_Deduction
    var F_PromotionID = 0//促销ID
    
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
    
    static func requestList() {
        NetworkManager.requestListModel(params: ["method":"apishopcartlist"]).setSuccessAction { (bm: BaseModel<CarModel>) in
            if let list = bm.list {
                CarModel.items = list
            }
        }
    }
    
    ///传入id判断原来是否已有，不传就直接去items的数量
    static func getCount(carId: Int? = nil) -> Int {
        if let id = carId {
            for item in items {
                if item.F_ID == id {
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
        NetworkManager.requestModel(params: ["method":"apiupdateshopcartcount", "fId":self.F_ID, "fCout":self.F_Count], success: { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                
            }
        }) { (err) in
            
        }
    }
    
    func delete(complete: BLANK_CLOSURE?) {
        NetworkManager.requestModel(params: ["method":"apidelshopcart", "fId":self.F_ID], success: { (bm: BaseModel<CodeModel>) in
            CarModel.items = CarModel.items.filter({ $0.F_ID != self.F_ID })
            bm.whenSuccess {
                complete?()
            }
        }) { (err) in
            MBProgressHUD.show(errorText: "请求失败")
        }
    }
}


class CarRealmModel: Object {
    var F_Deduction = 0.0//减额,type=3时使用,满F_Price减F_Deduction
    var F_Count = 1
    var F_Type = 0//类型 0:普通 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    var F_PurchaseCount = 0//单人限购数量(type不为0时使用,修改数量时需要限制)
    var F_PState = 0//促销状态(type不为0时使用,判断此值为1时才能提交订单)
    var F_SaleState = 0//促销上架状态(type不为0时使用,判断此值为1时才能提交订单)
    var F_State = false//0:未上架 1:已上架(type为0需要判断)
    var F_IsDel = false//是否删除 0:否 1:是(type为0需要判断)
    var F_PromotionCount = 0//促销总数量(type不为0时使用)
    var F_PromotionPrice = 0.0//活动价(团购,秒杀用)
    var F_Discount = 0.0//折扣,type=6时使用,最终价格为F_SalePrice*F_Discount
    var F_SalesPrice = 0.0//销售价(type为0表示销售价,不为0表示原价)
    var F_ExString = ""//所选规格信息
    var F_GoodsID = 0//商品ID
    var F_GoodsName = ""//商品名称
    var F_UserAccountID = 0//用户ID
    var F_MIntegral = 0.0//多倍积分倍数,type=5时使用
    var F_ID = 0//购物车ID
    var F_GoodImg = ""//商品图片
    var F_PEID = 0//促销扩展信息ID
    var F_GEID = 0//商品扩展信息ID
    var F_Price = 0.0//满额,type=3时使用,满F_Price减F_Deduction
    var F_PromotionID = 0//促销ID
    
    override static func primaryKey() -> String? {
        return "F_GEID"
    }
}
