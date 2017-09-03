//
//  OrderModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/5.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class OrderModel: CustomTableViewCellItem {
    
    var type = OrderVC.OrderType.all

    var fPromotiontype = 0//促销类别 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    var fSaleamount = 0.0//订单商品总额
    var fExpress = ""//快递单号
    var fPrice = 0.0//满额
    var fPaidfreight = 0.0//实付运费
    var fConcessions = 0.0//手动优惠金额(负数)
    var fAddressphone = ""//收货电话
    var fAddress = ""//收货地址
    var fDeduction = 0.0//减额
    var fIntegralamount = 0.0//积分抵用金额(负数)
    var fOrderid = 0 //订单ID
    var fAccountid = 0//用户ID
    var fDiscount = 0.0//折扣
    var fPromotionid = 0//促销ID
    var fShopid = 1//店铺ID
    var fFreight = 0.0 //运费
    var fAddressname = ""//收货人
    var fState = 0// 0待付款 1已付款 2待发货 3已发货 4完成 5关闭
    var fCreatetime = 0//账单建立时间
    var fIntegral = 0//可用积分
    var fMintegral = 0.0//多倍积分倍数
    var fType = -1
    var orderEx = [OrderEXModel]()
}

class OrderEXModel: NSObject, ParseModelProtocol {
    override required init() {
        super.init()
    }
    
    var fCount =  0 //购买数量
    var fPeid = 0 //促销明细ID
    var fUnitprice = 0.0//商品单价
    var fExpayamount = 0.0//商品实际付款金额
    var fExsaleamount = 0.0//商品实际销售金额
    var fGoodsid = 0 //商品ID
    var fOeid =  0  //订单明细ID
    var fSpecifications =  ""//商品类型
    var fGoodsname = ""//商品名称
    var fUrl = ""
    
}
