//
//  PreCreateOrder.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/28.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class PreCreateOrder: CustomTableViewCellItem {
    var saleAmount = 0.0//商品销售总额
    var payFreight = 0.0//运费
    var canUseIntegral = 0//可用积分(使用积分时必须使用这么多)
    var integralAmount = 0.0//使用积分可抵扣的金额（负数）
    var payAmount = 0.0//需要支付的金额（应付商品金额+运费）
    var IDS = ""//订单ID串
    var deDuction = 0.0//优惠折扣金额（负数）
}
