//
//  ReturnedModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/8/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ReturnedModel: CustomTableViewCellItem {
    var fReturnid = 0//退换货单ID
    var fOrderid = 0 //订单ID
    var fAccountid = 0 //用户ID
    var fSaleamount = 0.0 //商品价格
    var fCount =  0// 可退数量或已退数量
    var fGeid = 0//商品明细ID
    var F_Specifications = ""//购买商品规格
    var fIsreturned = 0//是否可退货 0 否 1 是
    var fIschanged = 0//是否可换货 0 否 1 是
    var fGoodsid = 0//商品ID
    var fState = -1 // 退货状态 null 显示申请换货按钮  0待审核 1待回寄 2待发货\待退款 3待收货 4完成
    var fOeid = 0 //订单明细ID
    var fGoodsname = ""//商品名称
    var fUrl = ""//商品图片
}
