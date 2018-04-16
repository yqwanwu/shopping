//
//  ExpressInfoModel.swift
//  Shopping_W
//
//  Created by wanwu on 2018/4/16.
//  Copyright © 2018年 wanwu. All rights reserved.
//

import UIKit

class ExpressInfoModel: NSObject, ParseModelProtocol {
    var F_ExpressID = 0
    var F_CodeName = "" // :"AJ/安捷快递",
    var F_Name = ""//":"安捷快递",
    var F_Code = ""//:"AJ"
    
    override required init() {
        super.init()
    }
}

