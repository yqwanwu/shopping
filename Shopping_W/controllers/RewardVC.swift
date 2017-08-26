//
//  RewardVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class RewardModel: CustomTableViewCellItem {
    var fLevelpercentage = 0 //当前享受奖励比列
    var fSumlevelintegral = 0//当前等级积分
    var fLevelintegraltext = ""//当前等级
}

class RewardVC: BaseViewController {

    @IBOutlet weak var gotBtn: UIButton!
    @IBOutlet weak var tableView: RefreshTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的奖励"
        
        // cell 130
        tableView.sectionHeaderHeight = 10
        reqeustData()
        gotBtn.isEnabled = false
        gotBtn.layer.cornerRadius = CustomValue.btnCornerRadius
    }
  
    func reqeustData() {
        NetworkManager.requestTModel(params: ["method":"apigetlevelintegralsum"]).setSuccessAction { (bm: BaseModel<RewardModel>) in
            bm.whenSuccess {
                let data = bm.t!.build(cellClass: RewardTableViewCell.self).build(heightForRow: 100).build(isFromStoryBord: true)
                self.tableView.dataArray = [[data]]
                self.tableView.reloadData()
                self.gotBtn.isEnabled = true
                self.gotBtn.backgroundColor = CustomValue.common_red
            }
            bm.whenNoData {
                self.nomalLevel()
            }
        }
    }

    func nomalLevel() {
        let r = RewardModel().build(cellClass: RewardTableViewCell.self).build(heightForRow: 100).build(isFromStoryBord: true)
        r.fLevelintegraltext = "普通"
        self.tableView.dataArray = [[r]]
        self.tableView.reloadData()
        self.gotBtn.backgroundColor = UIColor.lightGray
        self.gotBtn.isEnabled = false
    }
    
    @IBAction func ac_get(_ sender: Any) {
        NetworkManager.requestTModel(params: ["method":"apiChangelevelintegral"]).setSuccessAction { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                MBProgressHUD.show(successText: "提取成功")
                self.nomalLevel()
            }
        }
    }
}
