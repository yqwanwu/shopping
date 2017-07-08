//
//  GoodsModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class GoodsModel: CustomTableViewCellItem {
/**
     "fShopname": null,  //店铺名称
     "fPromotiontype": 0, // 正在参与促销类别 0:无 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
     "fNo": "ASS", //货号
     "fCategoryname": "花盆花器", //分类名称
     "fGoodsid": 3, //商品ID
     "fSalesprice": 489.00, //单价
     "fShopid": 3, //店铺ID
     "fStock": 9999, //库存
     "fTags": "清真专区", //标签
     "fCategoryid": 30, //分类ID
     "fGoodsname": "韩国夏装新款背带碎花雪纺连衣裙中长款宽松显瘦荷叶边无袖吊带裙", //商品名称
     "fGoodscode": "333120", //商品编码
     "fUrl": "\\upload\\2017-06\\20170602000710_5dbf3b00-b2e2-4ffd-bba2-88fc51363c2f.jpg" //商品主图
 */
    
    var fShopname = ""
    ///正在参与促销类别 0:无 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分
    var fPromotiontype = 0
    var fNo = ""
    var fCategoryname = ""
    var fGoodsid = 0
    var fSalesprice = NSNumber(value: 0.0)
    var fShopid = 0
    var fStock = 0
    ///标签
    var fTags = ""
    ///分类ID
    var fCategoryid = 0
    var fGoodsname = ""
    /////商品编码
    var fGoodscode = ""
    var fUrl = ""

}
