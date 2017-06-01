//
//  BalanceVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/1.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

///余额
class BalanceVC: BaseViewController, UITableViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: RefreshTableView!
    @IBOutlet weak var headerBk: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    
    enum VCType {
        case balance, integral
    }
    
    var type = VCType.balance

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = type == .balance ? "我的余额" : "我的积分"
        
        if type == .integral {
            logoView.image = #imageLiteral(resourceName: "p4.5-我的积分")
            headerBk.backgroundColor = UIColor.hexStringToColor(hexString: "fdb82d")
            tipLabel.text = "此积分可在结账时直接时可用"
        }
        
        let c = CustomTableViewCellItem().build(cellClass: BalanceTableViewCell.self).build(isFromStoryBord: true).build(heightForRow: 50)
        tableView.dataArray = [[c, c, c, c]]
        tableView.delegate = self
    }
    
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = type == .balance ? "余额记录" : "积分记录"
        
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
