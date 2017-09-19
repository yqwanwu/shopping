//
//  SettingsVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SettingsVC: BaseViewController, UITableViewDelegate {
    
    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        return t
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
        self.view.addSubview(tableView)

        let data = ["关于", "评价软件" , "建议", "客服中心"].map { (t) -> CustomTableViewCellItem in
            return CustomTableViewCellItem().build(text: t).build(cellClass: NormalTableViewCell.self).build(accessoryType: .disclosureIndicator).build(heightForRow: 50)
        }
        tableView.delegate = self
        tableView.dataArray = [data]
        tableView.sectionHeaderHeight = 10
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
        let btn = UIButton(frame: CGRect(x: 50, y: 20, width: view.frame.width - 100, height: 45))
        btn.backgroundColor = CustomValue.common_red
        btn.layer.cornerRadius = CustomValue.btnCornerRadius
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("退出登录", for: .normal)
        footerView.addSubview(btn)
        tableView.tableFooterView = footerView
        btn.addTarget(self, action: #selector(ac_out), for: .touchUpInside)
        
    }
    
    func ac_out() {
        let p = PersonMdel.readData()
        p?.fUserpass = ""
        p?.saveData()
        self.navigationController?.popToRootViewController(animated: false)
        CustomTabBarVC.instance.selectedIndex = 0
        LoginVC.showLogin()
    }
    
  
    //MARK: 代理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            let vc = TextVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            self.navigationController?.pushViewController(CustomerServicesVC(), animated: true)
        default:
            break
        }
    }

}
