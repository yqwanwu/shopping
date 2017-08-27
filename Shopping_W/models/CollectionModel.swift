//
//  CollectionModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/8/27.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CollectionModel: CustomTableViewCellItem {
    var F_Deduction = 0.0//减额
    var F_PicUrl = ""//商品图片
    var F_Type = 0//促销类别 0:普通 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    var F_Discount = 0.0////折扣
    var F_PromotionPrice = 0.0//促销价格
    var F_StartTime = 0.0//促销开始时间
    var F_Summary = ""//商品摘要
    var F_FavoritesID = 0//收藏ID
    var F_GoodsID = 0//商品ID
    var F_UserID = 0
    var F_GoodsName = ""//商品名称
    var F_MIntegral = 0.0//多倍积分
    var F_salesprice = 0.0//销售价格
    var F_CreateTime = 0//记录创建时间
    var F_Price = 0.0//满额
    var F_EndTime = 0//促销结束时间
    var F_PromotionID = 0//促销ID
    
    var F_BrowseLogID = 0
}
