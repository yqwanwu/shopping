//
//  LogisticsVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

///物流
class LogisticsVC: BaseViewController {

    @IBOutlet weak var tableView: CustomTableView!
    var fOrderid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        requestData()
    }

    func requestData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestTModel(params: ["method": "apigetExpressInfo", "fOrderid": fOrderid]).setSuccessAction { (bm: BaseModel<LogisticsModelTop>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                var i = 0
                let arr = bm.t!.Traces.map({ (m) -> LogisticsModel in
                    m.build(cellClass: LogisticsCell.self)
                        .build(isFromStoryBord: true)
                        .build(heightForRow: 110)
                    if i == 0 {
                        m.isLast = true
                        i = 2
                    }
                    return m
                })
                self.tableView.dataArray = [arr]
                self.tableView.reloadData()
            }
        }
    }

}

