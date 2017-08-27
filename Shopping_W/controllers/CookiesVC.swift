//
//  CookiesVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class CookiesVC: BaseViewController, UITableViewDelegate {
    lazy var tableView: RefreshTableView = {
        let t = RefreshTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64), style: .plain)
        t.sectionHeaderHeight = 8
        t.delegate = self
        return t
    } ()
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "浏览记录"
        
        self.view.addSubview(tableView)
        
        tableView.addFooterAction { [unowned self] _ in
            self.currentPage = 1
            self.requestData()
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        requestData()
//        let c = OrderModel().build(cellClass: OrerListCell.self).build(heightForRow: 118)
//        c.type = .cookies
//        tableView.dataArray = [[c, c, c, c]]
    }
    
    func requestData() {
        let params = ["method":"apiBrowseLogList", "currentPage":currentPage, "pageSize":CustomValue.pageSize] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params).setSuccessAction { (bm: BaseModel<CollectionModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                if !bm.pageInfo!.hasNextPage {
                    self.tableView.noMoreData()
                }
                
                var arr = bm.pageInfo!.list!.map({ (model) -> CollectionModel in
                    model.build(cellClass: GoodsCommonTableViewCell.self).build(heightForRow: 118)
                    model.setupCellAction({ [unowned self] (idx) in
                        let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
                        switch model.F_Type {
                        case 0:
                            vc.type = .normal
                        case 1:
                            vc.type = .group
                        case 2:
                            vc.type = .seckill
                        case 3, 4, 5, 6:
                            vc.type = .promotions
                        default:
                            break
                        }
                        vc.promotionid = model.F_PromotionID
                        vc.goodsId = model.F_GoodsID
                        vc.picUrl = model.F_PicUrl
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    return model
                })
                
                if !arr.isEmpty {
                    if !self.tableView.dataArray.isEmpty {
                        arr.insert(contentsOf: (self.tableView.dataArray[0] as! [CollectionModel]), at: 0)
                    }
                    self.tableView.dataArray = [arr]
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK:代理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ac = UITableViewRowAction(style: .default, title: "删除") { [unowned self] (action
            , idx) in
            let data = self.tableView.dataArray[indexPath.section][indexPath.row] as! CollectionModel
            NetworkManager.requestTModel(params: ["method":"apiBrowseLogDel", "fBrowselogid":data.F_BrowseLogID]).setSuccessAction(action: { (bm: BaseModel<CodeModel>) in
                bm.whenSuccess {
                    self.tableView.dataArray[idx.section].remove(at: idx.row)
                    self.tableView.deleteRows(at: [idx], with: .left)
                }
            })
        }
        
        return [ac]
    }

}
