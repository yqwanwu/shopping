//
//  CookiesVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CookiesVC: BaseViewController, UITableViewDelegate {
    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        t.sectionHeaderHeight = 8
        t.delegate = self
        return t
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "浏览记录"
        
        self.view.addSubview(tableView)
        
        let c = OrderModel().build(cellClass: OrerListCell.self).build(heightForRow: 118)
        c.type = .cookies
        tableView.dataArray = [[c, c, c, c]]
    }
    
    //MARK:代理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ac = UITableViewRowAction(style: .default, title: "删除") { [unowned self] (action
            , idx) in
            self.tableView.dataArray[idx.section].remove(at: idx.row)
            self.tableView.deleteRows(at: [idx], with: .left)
        }
        
        return [ac]
    }

}
