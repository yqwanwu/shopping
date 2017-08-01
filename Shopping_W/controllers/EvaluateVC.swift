//
//  EvaluateVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class EvaluateVC: BaseViewController {

    @IBOutlet weak var tableView: RefreshTableView!
    
    var goodsId = 0
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.addFooterAction { [unowned self] _ in
            self.currentPage += 1
            self.requestData()
        }
        
        tableView.addHeaderAction { [unowned self] _ in
            self.currentPage = 1
            self.requestData()
        }
        
        self.tableView.beginHeaderRefresh()
    }
    
    func requestData() {
        /*
         method	string	apievaluations	无
         fGoodsid	number	自行获取	商品ID
         fStartext	string	好评 中评 差评	查询所有评价传入''
         currentPage	number	自行获取	当前页
         pageSize	number	自行获取	页大小
 */
        let params = ["method":"apievaluations", "fGoodsid":goodsId, "fStartext":"", "currentPage":currentPage, "pageSize":CustomValue.pageSize] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params).setSuccessAction { (bm: BaseModel<EvaluationModel>) in
            self.tableView.endHeaderRefresh()
            self.tableView.endFooterRefresh()
            bm.whenSuccess {
                
                let list = bm.pageInfo!.list!.map({ (model) -> EvaluationModel in
                    model.build(cellClass: EvaluateCell.self)
                    return model
                })
                if !bm.pageInfo!.hasNextPage {
                    self.tableView.noMoreData()
                }
                
                if self.currentPage == 1 {
                    self.tableView.dataArray = [list]
                } else {
                    if let arr = self.tableView.dataArray.first as? [EvaluationModel] {
                        var newArr = arr
                        newArr.append(contentsOf: list)
                        self.tableView.dataArray = [newArr]
                    }
                    
                }
                self.tableView.reloadData()
            }
        }
    }

}
