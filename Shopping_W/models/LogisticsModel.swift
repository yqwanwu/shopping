//
//  LogisticsModel.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class LogisticsModel: CustomTableViewCellItem {
    var isLast = false
    var AcceptStation = ""
    var AcceptTime = ""
}

class LogisticsModelTop: CustomTableViewCellItem {
    var LogisticCode = ""
    var ShipperCode = ""
    var Traces = [LogisticsModel]()
}
