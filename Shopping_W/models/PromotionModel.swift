//
//  PromotionModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit


///促销
class PromotionModel: CustomTableViewCellItem {
/**
     "fNo": "7",//货号
     "fPurchasecount": 3,//限购数量
     // 商品类型，显示 isshow=1 的信息
     "fExparams": "[{\"name\": \"适用场景\", \"value\": \"8\", \"isshow\": 1}, {\"name\": \"颜色\", \"value\": \"9\", \"isshow\": 1}, {\"name\": \"风格\", \"value\": \"\", \"isshow\": 1}, {\"name\": \"植物种类\", \"value\": \"\"}, {\"name\": \"仿真花类型\", \"value\": \"\"}]",
     "fStarttime": "2017-06-13 23:06:48",//开始时间
     "fCategoryname": "仿真植物",//分类名称
     "fPromotionid": 5, //促销ID
     "fState": 0,//0未开始 1 进行中 2待发货 3已发货 4未成团 5已退款
     "fMintegral": 1200,//多倍积分倍数
     "fPromotioncount": 1000,//促销数量
     "fFreegoodname": null,//买赠商品名称
     "fFreegoodId": null,//买赠商品ID
     "fSalescount": null,//已卖出数量
     "fSalesprice": 3,//单价
     "fStatename": "未开始",//状态名称
     "fSalestate": 0,//0未上架 1 已上架 2 自动下架
     "fPrice": 1000,//满额
     "fGoodsname": "顶戴dsf",//商品名称
     "fDeduction": 200,//减额
     "fTypename": "多倍积分",//促销类别名称
     "fPromotionprice": null,//团购价格或者秒杀价格
     "fShopname": "水果旗舰店",//店铺名称
     "fSalestatename": "未上架",//上架状态名称
     "fDiscount": null,//折扣
     "fSummary": null,//商品摘要
     "fShopid": 1,//商店ID
     "fCategoryid": 14,//分类ID
     "fEndtime": "2017-07-02 23:06:50",结束时间
     "fType": 5 //促销类别 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
*/
    var type = GoodsListVC.ListType.normal

    var fNo = ""
    var fPurchasecount = 0
    ///json
    var fExparams = ""
    var fStarttime = ""
    var fCategoryname = ""
    var fPromotionid = 0
    var fState = 0
    var fMintegral = 0
    var fPromotioncount = 0
    var fFreegoodname = ""
    var fFreegoodId = -1
    var fSalescount = -1
    var fSalesprice: NSNumber?
    var fStatename = ""
    var fSalestate = 0
    
    var fPrice: NSNumber?
    var fGoodsname = ""
    var fDeduction: NSNumber?
    var fTypename = ""
    var fPromotionprice: NSNumber?
    var fShopname = ""
    var fSalestatename = ""
    var fDiscount = 0.0
    var fSummary = ""
    var fShopid = 0
    var fCategoryid = 0
    var fEndtime = ""
    var fType = 0
}
