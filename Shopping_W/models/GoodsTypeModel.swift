//
//  GoodsTypeModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class GoodsTypeModel: NSObject, ParseModelProtocol {
    
    var fNo = ""
    var fGeid = 1
    var fSalesprice = 0.0
    var fWeight = 0.0
    var fExparams = ""
    var fStock = 0

    var isSelected = false
    
    override required init() {
        super.init()
    }
    
}
