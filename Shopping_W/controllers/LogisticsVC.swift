//
//  LogisticsVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

///物流
class LogisticsVC: BaseViewController {

    @IBOutlet weak var tableView: CustomTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let c = LogisticsModel().build(cellClass: LogisticsCell.self).build(isFromStoryBord: true)
        c.isLast = true
        let c1 = LogisticsModel().build(cellClass: LogisticsCell.self).build(isFromStoryBord: true)
        
        tableView.dataArray = [[c, c1, c1 , c1]]
    }

}

