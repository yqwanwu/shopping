//
//  RegisterVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class RegisterVC: BaseViewController {

    @IBOutlet weak var tableView: CustomTableView!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        setupTableView()
    }

    func setupTableView() {
        tableView.sectionHeaderHeight = 10
        let c = CustomTableViewCellItem().build(text: "用户名:").build(detailText: "请输入用户名")
        let c1 = CustomTableViewCellItem().build(text: "密码:").build(detailText: "密码至少6位")
        let c2 = CustomTableViewCellItem().build(text: "确认密码:").build(detailText: "密码至少6位")
        let c3 = CustomTableViewCellItem().build(text: "手机号:").build(detailText: "请输入手机号")
        let c4 = CustomTableViewCellItem()
            .build(text: "验证码:").build(heightForRow: 50)
            .build(isFromStoryBord: true)
            .build(cellClass: RegisterCodeTableViewCell.self)
        
        var datas = [[c, c1, c2, c3]].map({ (item) -> [CustomTableViewCellItem] in
            return item.map({ (c) -> CustomTableViewCellItem in
                c.build(cellClass: RegisterTableViewCell.self)
                    .build(isFromStoryBord: true)
                    .build(heightForRow: 50)
            })
        })
        
        datas[0].append(c4)
        
        tableView.dataArray = datas
    }
    
    @IBAction func ac_register(_ sender: UIButton) {
        
    }

}
