//
//  MyCollectionVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class MyCollectionVC: BaseViewController {

    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        t.sectionHeaderHeight = 8

        return t
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的收藏"
        
        self.view.addSubview(tableView)
        
        let c = OrderModel().build(cellClass: OrerListCell.self).build(heightForRow: 118)
        c.type = .myCollection
        tableView.dataArray = [[c, c, c, c]]
    }

}
