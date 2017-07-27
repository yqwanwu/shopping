//
//  FirstItem.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/23.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class FirstItem: CustomTableViewCellItem {
    var imgName = ""
    
    var fLabelid = 0
    var fLabelname = ""

    
    var type = GoodsListVC.ListType.normal
    
    convenience init(title: String, imgName: String) {
        self.init()
        self.fLabelname = title
        self.imgName = imgName
    }
    
    static var defaultDatas: [FirstItem] = {
        var arr = [FirstItem]()
        arr.append(FirstItem(title: "全部分类", imgName: "分类"))
//        arr.append(FirstItem(title: "健康中国", imgName: "健康"))
        arr.append(FirstItem(title: "秒杀", imgName: "秒杀"))
//        arr.append(FirstItem(title: "特色中国", imgName: "特色中国"))
        arr.append(FirstItem(title: "团购", imgName: "团购"))
//        arr.append(FirstItem(title: "清真专区", imgName: "清真专区"))
        arr.append(FirstItem(title: "促销", imgName: "促销"))
//        arr.append(FirstItem(title: "绿色中国", imgName: "绿色专区"))
        return arr
    } ()
    
    

}
