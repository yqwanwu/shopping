//
//  AddressModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class AddressModel: NSObject {
    var fAddressid = 1//用户地址主键
    var fAccountid = 1//用户ID
    var fPhone = "123456789"//收货电话
    var fAddress = "四川省成都市高新区xxxxxx"//收货地址
    var fName = "张三"//收件人姓名
    var fAddressparams = ""//"{\"area\ = \"高新区\" \"city\ = \"成都市\" \"address\ = \"xxxxxx\" \"province\ = \"四川省\"}" //地址json
    var fTagname = "公司"//标签
    var fType = 1 //类型 1默认 0 其他
}
