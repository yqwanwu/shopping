//
//  MyEvaluateListVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class MyEvaluateListVC: BaseViewController {
    
    lazy var tableView: RefreshTableView = {
        let t = RefreshTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        t.sectionHeaderHeight = 8

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
                var arr = bm.pageInfo!.list!.map({ $0.fList }).flatMap({ $0 })
                    .map({ (model) -> MyEvaluationModelItem in
                    model.build(cellClass: OrerListCell.self).build(heightForRow: 118)
                    return model
                })
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
    var fGoodsid = ""//商品id
    var fStar = 0//评价星级
}
