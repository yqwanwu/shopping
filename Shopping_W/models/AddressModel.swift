//
//  AddressModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

extension Object {
    func parseSameNSObject<T: CustomTableViewCellItem>() -> T {
        let c = T()
        let m = Mirror(reflecting: c)
        for child in m.children {
            let name = child.label ?? ""
            if let v = self.value(forKey: name) {
                c.setValue(v, forKey: name)
            }
        }
        return c
    }
}

class AddressRealmModel: Object, ParseModelProtocol {
    dynamic var fAddressid = 1//用户地址主键
    dynamic var fAccountid = 1//用户ID
    dynamic var fPhone = ""//收货电话
    dynamic var fAddress = ""//收货地址
    dynamic var fName = ""//收件人姓名
    dynamic var fAddressparams = ""//"{\"area\ = \"高新区\" \"city\ = \"成都市\" \"address\ = \"xxxxxx\" \"province\ = \"四川省\"}" //地址json
    dynamic var fTagname = ""//标签
    dynamic var fType = -1 //类型 1默认 0 其他
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
}

class AddressModel: CustomTableViewCellItem {
    var fAddressid = 0//用户地址主键
    var fAccountid = 0//用户ID
    var fPhone = ""//收货电话
    var fAddress = ""//收货地址
    var fName = ""//收件人姓名
    var fAddressparams = ""//"{\"area\ = \"高新区\" \"city\ = \"成都市\" \"address\ = \"xxxxxx\" \"province\ = \"四川省\"}" //地址json
    var fTagname = ""//标签
    var fType = -1 //类型 1默认 0 其他
    
    var updateAcrion: BLANK_CLOSURE?
    
    static var defaultAddress: AddressModel?
    
    static func requestData() {
        NetworkManager.requestListModel(params: ["method":"apiaddresslist"]).setSuccessAction { (bm: BaseModel<AddressModel>) in
            if let list = bm.list {
                if list.count > 0 {
                    self.defaultAddress = list.filter({$0.fType == 1}).last ?? list.first
                }
            }
        }
        
    }
}
