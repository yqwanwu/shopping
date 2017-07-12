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
    var fGoodsid = 0
    var fShopid = 0
    var fCategoryid = 0
    
    var fGoodsname = ""
    var fPromotiontype = 0
    var fContentapp = ""
    var fCategoryname = ""
    var fShopname = ""
    var fGoodscode = ""
    var fTags = ""
    var fParams = ""
    var fFivestarperc = 0
    
    var exList: [GoodsTypeModel]?
    var picList: [NSDictionary]?
    
    override required init() {
        super.init()
    }
    
    static func requestData(fGoodsid: Int, fGeid: Int?) -> BaseModel<GoodsDetailModel> {
        var params = ["method":"apigoodsdetail", "fGoodsid": "\(fGoodsid)"]
       
        if let id = fGeid {
            params["fGeid"] = "\(id)"
        }
        
        return NetworkManager.requestListModel(params: params)
    }
}
