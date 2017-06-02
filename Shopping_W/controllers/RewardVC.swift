//
//  RewardVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class RewardVC: BaseViewController {

    @IBOutlet weak var tableView: RefreshTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的奖励"
        
        // cell 130
        let c = CustomTableViewCellItem().build(cellClass: RewardTableViewCell.self).build(heightForRow: 130).build(isFromStoryBord: true)
        tableView.sectionHeaderHeight = 10
        tableView.dataArray = [[c], [c], [c]]
    }

  

}
