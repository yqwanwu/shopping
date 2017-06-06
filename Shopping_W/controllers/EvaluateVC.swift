//
//  EvaluateVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class EvaluateVC: BaseViewController {

    @IBOutlet weak var tableView: RefreshTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        let c = CustomTableViewCellItem().build(cellClass: EvaluateCell.self)
        tableView.dataArray = [[c, c, c]]
    }

}
