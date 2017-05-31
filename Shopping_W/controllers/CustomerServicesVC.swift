//
//  CustomerServicesVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CustomerServicesVC: UIViewController, UITableViewDelegate {
    
    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        return t
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "客服中心"
        self.view.addSubview(tableView)
        tableView.sectionHeaderHeight = 10
        
        let data = [["购物流程" , "支付方式"], ["退换货流程", "金额退回"]]
        tableView.delegate = self
        tableView.dataArray = data.map({ (arr) -> [CustomTableViewCellItem] in
            return arr.map({ (t) -> CustomTableViewCellItem in
                return CustomTableViewCellItem().build(text: t).build(cellClass: NormalTableViewCell.self).build(heightForRow: 50).build(accessoryType: .disclosureIndicator)
            })
        })
    }
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title = "购物"
        if section == 1 {
            title = "退换货"
        }
        
        let f = tableView.frame
        let v = UIView(frame: CGRect(x: 0, y: 0, width: f.width, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: f.width, height: 50))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        v.addSubview(label)
        label.text = title
        v.backgroundColor = UIColor.white
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}
