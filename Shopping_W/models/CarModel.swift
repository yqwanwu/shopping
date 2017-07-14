//
//  CarModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

typealias BLANK_CLOSURE = () -> Void

class CarModel: CustomTableViewCellItem {
    
    var F_Deduction = 0.0//减额,type=3时使用,满F_Price减F_Deduction
    var F_Count = 1 {//数量
        didSet {
            countAction?()
        }
    }
    var F_Type = 0//类型 0:普通 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    var F_PurchaseCount = 0//单人限购数量(type不为0时使用,修改数量时需要限制)
    var F_PState = 0//促销状态(type不为0时使用,判断此值为1时才能提交订单)
    var F_SaleState = 0//促销上架状态(type不为0时使用,判断此值为1时才能提交订单)
    var F_State = false//0:未上架 1:已上架(type为0需要判断)
    var F_IsDel = false//是否删除 0:否 1:是(type为0需要判断)
    var F_PromotionCount = 0//促销总数量(type不为0时使用)
    var F_PromotionPrice = 0.0//活动价(团购,秒杀用)
    var F_Discount = 0.0//折扣,type=6时使用,最终价格为F_SalePrice*F_Discount
    var F_SalesPrice = 0.0//销售价(type为0表示销售价,不为0表示原价)
    var F_ExString = ""//所选规格信息
    var F_GoodsID = 0//商品ID
    var F_GoodsName = ""//商品名称
    var F_UserAccountID = 0//用户ID
    var F_MIntegral = 0.0//多倍积分倍数,type=5时使用
    var F_ID = 0//购物车ID
    var F_GoodImg = ""//商品图片
    var F_PEID = 0//促销扩展信息ID
    var F_GEID = 0//商品扩展信息ID
    var F_Price = 0.0//满额,type=3时使用,满F_Price减F_Deduction
    var F_PromotionID = 0//促销ID
    
    var countAction: BLANK_CLOSURE?
    var isSelected = false {
        didSet {
            selectedAction?()
        }
    }
    var selectedAction: BLANK_CLOSURE?
}
