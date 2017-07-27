//
//  GoodsExtTypeModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/26.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsExtTypeModel: NSObject {
    var model = GoodsTypeModel()
    
    var name = ""
    var value = ""
    var isshow = false
    
    enum GoodTypeState {
        case disable, enable, title, selected
    }
    
    var state = GoodTypeState.enable
    
    static func gteArr(jsonString: String) -> [GoodsExtTypeModel] {
        let json = JSON(parseJSON: jsonString)
        var arr = [GoodsExtTypeModel]()
        for type in json.arrayValue {
            let tmp = GoodsExtTypeModel(json: type)
            arr.append(tmp)
        }
        
        return arr
    }
    
    init(json: JSON) {
        super.init()
        self.name = json["name"].stringValue
        self.value = json["value"].stringValue
        self.isshow = json["isshow"].boolValue
    }
    
    override init() {
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object == nil {
            return false
        }
        
        if let o = object as? GoodsExtTypeModel {
            return self.name == o.name && self.value == o.value && self.isshow == o.isshow
        }
        
        return false
    }
    
    override var hash: Int {
        var result = name.hash;
        result = 31 * result + value.hash
        result = 31 * result + (isshow ? 1 : 0);
        return result;
        
    }
}
