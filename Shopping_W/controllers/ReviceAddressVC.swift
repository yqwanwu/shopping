//
//  ReviceAddressVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/27.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ReviceAddressVC: BaseViewController {
    @IBOutlet weak var tableView: CustomTableView!
    let addVC = Tools.getClassFromStorybord(sbName: .mine, clazz: AddressUpdateVC.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBtn = UIButton(type: .system)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 52, height: 30)
        rightBtn.setTitle("新增", for: .normal)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.backgroundColor = CustomValue.common_red
        let item = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = item
        rightBtn.addTarget(self, action: #selector(ReviceAddressVC.ac_add), for: .touchUpInside)
        rightBtn.layer.cornerRadius = CustomValue.btnCornerRadius

        let c = CustomTableViewCellItem().build(cellClass: AddressTableViewCell.self).build(isFromStoryBord: true)
        tableView.estimatedRowHeight = 157
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataArray = [[c, c, c]]
        
        
        self.addChildViewController(addVC)
    }

    func ac_add() {
        view.addSubview(addVC.view)
    }

}
