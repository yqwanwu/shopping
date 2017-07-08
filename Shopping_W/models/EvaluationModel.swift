//
//  EvaluationModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

/**
 *   商品评价
 */
class EvaluationModel: CustomTableViewCellItem {
    var fEvaluationtime = "" //评价时间
    var fNickname = "" //用户昵称
    var fOrderid = 0 //订单ID
    var fStar = 0//评价等级
    var fOrdertime = ""//订单时间
    var fHeadimgurl = ""//头像地址，相对
    var fGoodsid = 1//商品ID
    var fEvaluationid = 4//评价ID
    var fStartext = ""//评价等级名称 好评 中评 差评
    var fContent = ""//评价内容
    var fSpecifications  = ""//用户购买规格 多个用逗号分割
}
