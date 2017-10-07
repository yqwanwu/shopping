//
//  CustomerServicesVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class CustomerServicesVC: UIViewController, UITableViewDelegate {
    
    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .grouped)
        return t
    } ()
    
    var list = [HelpsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "客服中心"
        self.view.addSubview(tableView)
        tableView.sectionHeaderHeight = 10
        tableView.delegate = self
        requestData()
    }
    
    func requestData() {
        MBProgressHUD.showAdded(to: view, animated: true)
        NetworkManager.requestPageInfoModel(params: ["method": "apihelps"]).setSuccessAction { (bm: BaseModel<HelpsModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                self.list = bm.pageInfo!.list!
                
                let data = self.list.map({ (model) -> [HelpsDetailModel] in
                    return model.fList.map({ (detail) -> HelpsDetailModel in
                        let c = detail.build(text: detail.fTitle).build(cellClass: NormalTableViewCell.self).build(heightForRow: 50).build(accessoryType: .disclosureIndicator)
                        c.setupCellAction({ [unowned self] (idx) in
                            let web = BaseWebViewController()
                            web.htmlStr = detail.fContent
                            self.navigationController?.pushViewController(web, animated: true)
                        })
                        return c
                    })
                })
                
                self.tableView.dataArray = data
                self.tableView.reloadData()

            }
        }
    }
    
    //MARK: 代理
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            break
//        default:
//            break
//        }
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = list[section].fTypename
        
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
