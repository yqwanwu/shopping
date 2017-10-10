//
//  MyEvaluateListVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class MyEvaluateListVC: BaseViewController, UITableViewDataSource {
    
    lazy var tableView: RefreshTableView = {
        let t = RefreshTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        t.sectionHeaderHeight = 8
        t.dataSource = self
        return t
    } ()
    
    var curentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的评价"
        
        self.view.addSubview(tableView)

        self.rquestData()
        tableView.addFooterAction { [unowned self] _ in
            self.rquestData()
        }
    }
    
    func rquestData() {
        NetworkManager.requestPageInfoModel(params: ["method":"apimyevaluations"]).setSuccessAction { (bm: BaseModel<MyEvaluationModel>) in
            self.tableView.endHeaderRefresh()
            self.tableView.endFooterRefresh()
            
            bm.whenSuccess {
                var arr = bm.pageInfo!.list!.map({ (model) -> [MyEvaluationModelItem] in
                    return model.fList.map({ (item) -> MyEvaluationModelItem in
                        item.fOrderid = model.fOrderid
                        item.build(cellClass: OrerListCell.self).build(heightForRow: 118)
                        
                        item.setupCellAction { [unowned self] (idx) in
                            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
//                            switch model.fType {
//                            case 0:
//                                vc.type = .normal
//                            case 1:
//                                vc.type = .group
//                            case 2:
//                                vc.type = .seckill
//                            case 3, 4, 5, 6:
//                                vc.type = .promotions
//                            default:
//                                break
//                            }
                            vc.goodsId = item.fGoodsid
                            vc.picUrl = item.fUrl
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                        return item
                    })
                }).flatMap({ $0 })
                    
                if self.curentPage > 1 {
                    arr.insert(contentsOf: self.tableView.dataArray[0] as! [MyEvaluationModelItem], at: 0)
                }
                
                if !bm.pageInfo!.hasNextPage {
                    self.tableView.noMoreData()
                }
                
                self.tableView.dataArray = [arr]
                self.tableView.reloadData()
                self.curentPage += 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.createDefaultCell(indexPath: indexPath) as! OrerListCell
        let model = self.tableView.dataArray[indexPath.section][indexPath.row] as! MyEvaluationModelItem
        cell.reciveAction = { [unowned self] () in
            let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: MyEvaluateVC.self) as! MyEvaluateVC
            vc.evaluateItem = model
            //rderModel.orderEx[0].fGoodsid, "fOrderid":orderModel.fOrderid,
            let order = OrderModel()
            vc.orderModel = order
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.logisticsAction = { [unowned self] () in
            let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: MyEvaluateVC.self) as! MyEvaluateVC
            vc.evaluateItem = model
            //rderModel.orderEx[0].fGoodsid, "fOrderid":orderModel.fOrderid,
            let order = OrderModel()
            vc.orderModel = order
            vc.canEdit = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }

}

class MyEvaluationModel: CustomTableViewCellItem {
    var fOrderid = 0
    var fList = [MyEvaluationModelItem]()
}

class MyEvaluationModelItem: CustomTableViewCellItem {
    var fUseraccountid = 0
    var fCreatetime = 0.0//评价时间
    var fContent = ""//评价内容
    var fUrl = ""//商品图片
    var fEvaluationid = 0//评价id
    var fGoodsname = ""//商品名称
    var fGoodsid = 0//商品id
    var fStar = 0//评价星级
    var fOrderid = 0
}
