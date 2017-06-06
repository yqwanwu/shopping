//
//  CollectionPopoverVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CollectionPopoverVC: UIViewController {
    @IBOutlet weak var tableView: CustomTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let c = CustomTableViewCellItem().build(cellClass: NormalTableViewCell.self).build(text: "收藏").build(heightForRow: 45)
        c.setupCellAction { (idx) in
            debugPrint("收藏")
        }
        
        let c1 = CustomTableViewCellItem().build(cellClass: NormalTableViewCell.self).build(text: "分享").build(heightForRow: 45)
        c1.setupCellAction { (idx) in
            debugPrint("分享")
        }
        tableView.dataArray = [[c, c1]]
        
    }


  
    

}
