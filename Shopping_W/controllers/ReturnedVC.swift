//
//  ReturnedVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ReturnedVC: BaseViewController, UITableViewDataSource {

    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        t.sectionHeaderHeight = 8
        t.dataSource = self
        return t
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "申请退单"
        
        self.view.addSubview(tableView)
        
        let c = OrderModel().build(cellClass: OrerListCell.self).build(heightForRow: 118)
        c.type = .returned
        
        let c1 = OrderModel().build(cellClass: OrerListCell.self).build(heightForRow: 118)
        c1.type = .returning
        
        tableView.dataArray = [[c, c, c, c1]]
    }
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.createDefaultCell(indexPath: indexPath) as! OrerListCell
        cell.reciveAction = { [unowned self] _ in
            let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: ReturnedDetailVC.self) as! ReturnedDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }

}
