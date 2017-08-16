//
//  SecKillModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SecKillModel: CustomTableViewCellItem {
    var fStarttime = 0.0
    var fEndtime = 0.0
    var fTime = ""
    var fDate = ""
    var exList = [SecKillExtModel]()
}


class SecKillExtModel: CustomTableViewCellItem {
    var fEndtime = 0.0
    var fPromotioncount = 0
    var fPurchasecount = 0
    var fSaleprice = 0.0
    var fOrder = 0
    var fPromotionprice = 0.0
    var fSummary = ""
    var fGoodsname = ""
    var fGoodsid = 0
    var fState = 0
    var fPromotionid = 0
    var fSalestate = 0
    var fPicurl = ""
    
    var type = GoodsListVC.ListType.seckill
}

