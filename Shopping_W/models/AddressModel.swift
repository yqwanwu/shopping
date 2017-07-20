//
//  AddressModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import RealmSwift

class AddressModel: CustomTableViewCellItem {
    var fAddressid = 1//用户地址主键
    var fAccountid = 1//用户ID
    var fPhone = ""//收货电话
    var fAddress = ""//收货地址
    var fName = ""//收件人姓名
    var fAddressparams = ""//"{\"area\ = \"高新区\" \"city\ = \"成都市\" \"address\ = \"xxxxxx\" \"province\ = \"四川省\"}" //地址json
    var fTagname = ""//标签
    var fType = -1 //类型 1默认 0 其他
    
    
    var updateAcrion: BLANK_CLOSURE?
    
}
