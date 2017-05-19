//
//  CategoryVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/18.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CategoryVC: BaseViewController {
    @IBOutlet weak var tableView: RefreshTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c = CustomTableViewCellItem().build(heightForRow: 50).build(cellClass: CustomTableViewCell.self).build(text: "")
        
        tableView.dataArray = [[c, c]]
        
        tableView.addHeaderAction {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { 
                self.tableView.pullTORefreshControl.header?.endRefresh()
            })
        }
        
        tableView.autoLoadWhenIsBottom = false
        
        tableView.addFooterAction {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.tableView.endFooterRefresh()
            })
        }
        
        tableView.beginHeaderRefresh()
    }


}
