//
//  GoodsDetailModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

/**
 "fGoodsid": 1, //商品ID
 "fShopid": 1,  //店铺ID
 "fCategoryid": 75, //分类ID
 "fGoodsname": "文艺范清新复古成衣热卖中 更多心仪产品持续上新",  //商品名称
 "fPromotiontype": 0, //正在参与促销类别 0:无 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
 "fContentapp": "<p>商品详情：文艺范清新复古成衣热卖中 更多心仪产品持续上新</p>", //商品详情APP
 "fCategoryname": "狗粮 ",//分类名称
 "fShopname": "水果旗舰店",//店铺名称
 "fGoodscode": "200310",//商品编码
 "fTags": "复古,文艺范",//商品标签
 "fParams": null,
 "fFivestarperc": 100, // 五星好评
 "exList": [ //商品类型列表
 {
 "fNo": "ASS",
 "fGeid": 1,
 "fSalesprice": 489.00, //单价
 "fWeight": 3.50, //重量 fExparams，表示商品属性，显示 isshow =1 的属性
 "fExparams": "[{\"name\": \"原产地\", \"value\": \"成都\", \"isshow\": 1}, {\"name\": \"品牌\", \"value\": \"DOGGLE\"}, {\"name\": \"净含量(g)\", \"value\": \"\"}, {\"name\": \"适用品种\", \"value\": \"\"}, {\"name\": \"适用阶段\", \"value\": \"\"}, {\"name\": \"食品口味\", \"value\": \"\"}]"
 },
 {
 "fNo": "QWE",
 "fGeid": 3,
 "fSalesprice": 111.00,
 "fWeight": 1.70,
 "fExparams": "[{\"name\": \"原产地\", \"value\": \"成都\", \"isshow\": 1}, {\"name\": \"品牌\", \"value\": \"DOGGLE\"}, {\"name\": \"净含量(g)\", \"value\": \"\"}, {\"name\": \"适用品种\", \"value\": \"\"}, {\"name\": \"适用阶段\", \"value\": \"\"}, {\"name\": \"食品口味\", \"value\": \"\"}]"
 }
 ],
 "picList": [//商品图片列表，可能有多个
 {
 "fPicid": 7,
 "fType": 0,
 "fOrder":1,//排序
 "fUrl": "\\upload\\2017-06\\20170601231907_e6c06efe-76a5-4ee4-891f-eb8155bc0d50.jpg" //图片地址，相对于网站根目录
 }
 ]
 }
 */

///商品详情
class GoodsDetailModel: NSObject, ParseModelProtocol {
    
    var fPromotiontype = 0
    var fCategoryname = ""
    var fShopname = ""
    var fParams = ""
    
    //促销
    var fstate = 0 // 0未开始 1 进行中 2待发货 3已发货 4未成团 5已退款
    var fGoodsid = 0 //促销商品ID
    var fFreegoodid = 0//赠送商品ID
    var fPurchasecount = 0 //限购数量
    var fStarttime = ""//活动开始时间
    var fPromotionid = 0//促销ID
    var fFivestarperc = 0//五星好评数
    var fMintegral = 0//多倍积分倍数
    var fPromotioncount = 0//促销数量
    var fFreegoodsname = ""//赠送商品名称
    var fStatename = ""
    var fPrice = 0.0  //满额
    var fGoodsname = ""
    var fsalestate = 0//0未上架 1 已上架 2 自动下架到期和完成后自动下架，手动下架显示未上架
    var fSalescount = 0//已卖出数量
    var fDeduction = 0//减额
    var fContentapp = ""//商品描述
    var fTypename = ""
    var fSalestatename = ""
    var fDiscount = 0.0//折扣
    var fSummary = ""//摘要
    var fShopid = 0 //商店ID
    var fTags = ""
    var fCategoryid = 244//分类ID
    var fEndtime = ""//结束时间
    var fGoodscode = ""//货号
    var fType = 0// 促销类别 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
    
    
    var exList: [GoodsTypeModel]?
    var picList: [NSDictionary]?
    
    override required init() {
        super.init()
    }
    
    static func requestData(fGoodsid: Int) -> BaseModel<GoodsDetailModel> {
        let params = ["method":"apigoodsdetail", "fGoodsid": "\(fGoodsid)"]
        
        return NetworkManager.requestListModel(params: params)
    }
}
