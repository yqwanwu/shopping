//
//  RegionModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/19.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class RegionModel: Object, ParseModelProtocol {
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    dynamic var fRegionid = 0
    dynamic var fParentid = 0
    dynamic var fName = ""
    dynamic var fType = 0
    dynamic var fIshot = 0
    dynamic var fOrder = 1
    
    override static func primaryKey() -> String? {
        return "fRegionid"
    }
    
    static func requestData() {
        let params = ["method":"apiregionlist", "fIshot":"0", "fType":"1,2,3"] as [String:Any]
        NetworkManager.requestListModel(params: params).setSuccessAction { (bm: BaseModel<RegionModel>) in
            let realm = try! Realm()
            
            try! realm.write {
                realm.delete(realm.objects(RegionModel.self))
                
                for obj in bm.list! {
                    realm.add(obj)
                }
            }
        }
    }
    
    ///获取所有省
    static func findAllProvince() -> Results<RegionModel> {
        let realm = try! Realm()
        
        return realm.objects(self).filter("fParentid = 0")
    }
    
    ///根据省找到 市
    static func findCity(provinceId: Int) -> Results<RegionModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("fParentid = %@", provinceId)
    }
    
    ///根据市找到 区
    static func findArea(cityId: Int) -> Results<RegionModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("fParentid = %@", cityId)
    }
    
    ///返回热门城市
    static func findHotCitys() -> Results<RegionModel> {
        let realm = try! Realm()
        let arr = realm.objects(self).filter("fIshot = 1")
        return arr
    }

    static func findAllCitys() -> Results<RegionModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("fType = 2")
    }
    
}
