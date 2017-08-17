//
//  ReturnedVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ReturnedVC: BaseViewController, UITableViewDataSource {

    lazy var tableView: RefreshTableView = {
        let t = RefreshTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64), style: .plain)
        t.sectionHeaderHeight = 8
        t.dataSource = self
        return t
    } ()
    
    static var needReload = false
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "申请退单"
        
        self.view.addSubview(tableView)
        
        self.tableView.addHeaderAction { [unowned self] _ in
            self.currentPage = 1
            self.requestData()
        }
        
        self.tableView.addFooterAction { [unowned self] _ in
            self.currentPage += 1
            self.requestData()
        }
        
        self.tableView.beginHeaderRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ReturnedVC.needReload {
            ReturnedVC.needReload = false
            self.tableView.beginHeaderRefresh()
        }
    }
    
    func requestData() {
        NetworkManager.requestPageInfoModel(params: ["method":"apirefundlist", "currentPage":currentPage, "pageSize":CustomValue.pageSize]).setSuccessAction { (bm: BaseModel<ReturnedModel>) in
            bm.whenSuccess {
                self.tableView.endFooterRefresh()
                self.tableView.endHeaderRefresh()
                let arr = bm.pageInfo!.list!.map({ (model) -> ReturnedModel in
                    model.build(cellClass: OrerListCell.self).build(heightForRow: 118)
                    return model
                })
                
                if !bm.pageInfo!.hasNextPage {
                    self.tableView.noMoreData()
                }
                
                if self.currentPage == 1 {
                    self.tableView.dataArray = [arr]
                } else {
                    var list = self.tableView.dataArray[0] as! [ReturnedModel]
                    list.append(contentsOf: arr)
                    self.tableView.dataArray = [list]
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.createDefaultCell(indexPath: indexPath) as! OrerListCell
        let model = self.tableView.dataArray[indexPath.section][indexPath.row] as! ReturnedModel
        if model.fState < 0 {
            cell.reciveAction = { [unowned self] _ in
                let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: ReturnedDetailVC.self) as! ReturnedDetailVC
                vc.returnedModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }

}
