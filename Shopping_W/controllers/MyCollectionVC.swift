//
//  MyCollectionVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyCollectionVC: BaseViewController, UITableViewDelegate {

    lazy var tableView: RefreshTableView = {
        let t = RefreshTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        t.sectionHeaderHeight = 8
        t.delegate = self
        return t
    } ()
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的收藏"
        
        self.view.addSubview(tableView)

        tableView.addFooterAction { [unowned self] _ in
            self.currentPage += 1
            self.requestData()
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        requestData()
    }
    
    func requestData() {
        let params = ["method":"apiFavoritesList", "currentPage":currentPage, "pageSize":CustomValue.pageSize] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params).setSuccessAction { (bm: BaseModel<CollectionModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                if !bm.pageInfo!.hasNextPage {
                    self.tableView.noMoreData()
                }
                
                var arr = bm.pageInfo!.list!.map({ (model) -> CollectionModel in
                    model.build(cellClass: GoodsCommonTableViewCell.self).build(heightForRow: 118)
                    model.setupCellAction({ [unowned self] (idx) in
                        let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) 
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
                        vc.picUrl = model.F_PicUrl
                        vc.promotionid = model.F_PromotionID
                        vc.goodsId = model.F_GoodsID
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

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ac = UITableViewRowAction(style: .default, title: "删除") { (a, index) in
            MBProgressHUD.showAdded(to: self.view, animated: true)
            var arr = self.tableView.dataArray[0] as! [CollectionModel]
            NetworkManager.requestTModel(params: ["method":"apiFavoritesDel", "fFavoritesid":arr[index.row].F_FavoritesID]).setSuccessAction(action: { (bm: BaseModel<CodeModel>) in
                MBProgressHUD.hideHUD(forView: self.view)
                bm.whenSuccess {
                    arr.remove(at: index.row)
                    self.tableView.dataArray = [arr]
                    tableView.deleteRows(at: [index], with: .automatic)
                }
            })
        }
        return [ac]
    }
}
