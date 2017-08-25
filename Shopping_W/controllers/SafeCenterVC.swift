//
//  SafeCenterVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SafeCenterVC: BaseViewController {

    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .grouped)
        t.sectionHeaderHeight = 8
        return t
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "安全中心"
        
        self.view.addSubview(tableView)
        
        let c = CustomTableViewCellItem().build(text: "登录密码").build(cellClass: RightTitleCell.self).build(heightForRow: 50).build(accessoryType: .disclosureIndicator)
        let c1 = CustomTableViewCellItem().build(text: "手机号").build(detailText: "124324324").build(cellClass: RightTitleCell.self).build(heightForRow: 50).build(accessoryType: .disclosureIndicator)
        let c2 = CustomTableViewCellItem().build(text: "支付密码").build(cellClass: RightTitleCell.self).build(heightForRow: 50).build(accessoryType: .disclosureIndicator)
        let c3 = CustomTableViewCellItem().build(text: "密保问题").build(cellClass: RightTitleCell.self).build(heightForRow: 50).build(accessoryType: .disclosureIndicator)
        
        c.setupCellAction { [unowned self] (idx) in
//            let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: ModifyPwdVC.self)
//            self.present(vc, animated: false, completion: nil)
            
            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: ForgetPwdVC.self) as! ForgetPwdVC
            vc.type = .c
            self.navigationController?.pushViewController(vc, animated: true)
        }
        c1.setupCellAction { [unowned self] (idx) in
            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: ForgetPwdVC.self) as! ForgetPwdVC
            vc.isModify = true
            vc.type = .t
            self.navigationController?.pushViewController(vc, animated: true)
        }
        c2.setupCellAction { [unowned self] (idx) in
            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: ForgetPwdVC.self) as! ForgetPwdVC
            vc.type = .p
            self.navigationController?.pushViewController(vc, animated: true)
        }
        c3.setupCellAction { [unowned self] (idx) in
            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: ForgetPwdVC.self) as! ForgetPwdVC
            vc.isModify = true
            vc.selectPhone = false
            vc.type = .m
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.dataArray = [[c, c1, c2, c3]]
    }


}
