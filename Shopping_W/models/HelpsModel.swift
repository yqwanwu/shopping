//
//  HelpsModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/10/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class HelpsModel: CustomTableViewCellItem {
    var fId = 0
    var fType = 0
    var fTitle = ""
    var fContent = ""
    var fTime = ""
    var fTypename = ""//类型
    var fList = [HelpsDetailModel]()
}


class HelpsDetailModel: CustomTableViewCellItem {
    var fId = 0//id
    var fContent = ""//内容
    var fTime = ""//添加时间
    var fTitle = ""//标题
}
