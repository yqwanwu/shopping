//
//  GoodsListVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/1.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class GoodsListVC: BaseViewController {
    @IBOutlet weak var tableView: RefreshTableView!
    @IBOutlet weak var headerView: TabView!
    
    enum ListType: String {
        ///   二级页面  团购   秒杀      一般的   促销
        case level2, group = "1", seckill = "2", normal, promotions = "3,4,5,6"
    }
    
    var tags = ""
    var currentPage = 1
    
    var type = ListType.normal
    
    var fOrderbys = ""
    var categoryId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.dataArray = [[c, c, c, c]]
        
        setupTabView()
        
        self.tableView.addFooterAction { [unowned self] _ in
            self.currentPage += 1
            self.requestPromotions()
        }
        
        self.tableView.addHeaderAction { [unowned self] _ in
            self.currentPage = 1
            self.requestPromotions()
        }
        self.tableView.beginHeaderRefresh()
    }
    
    ///促销列表
    func requestPromotions() {
        if type != .normal && type != .level2 {
            var params = ["method":"apipromotions", "fTypes":type.rawValue, "fStates":"0,1,2,3,4", "fSalestates":"0,1,2", "currentPage":currentPage, "pageSize":20] as [String : Any]
            if fOrderbys != "" {
                params["fOrderbys"] = fOrderbys
            }
            
            NetworkManager.requestPageInfoModel(params: params, success: { (bm: BaseModel<PromotionModel>) in
                self.tableView.endHeaderRefresh()
                self.tableView.endFooterRefresh()
                bm.whenSuccess {
                    if let list = bm.pageInfo?.list {
                        self.dealModels(list: list)
                    }
                    if !(bm.pageInfo?.hasNextPage ?? false) {
                        self.tableView.pullTORefreshControl.footer?.state = .noMoreData
                    }
                }
            }) { (err) in
                
            }
        } else {
            var params = ["method":"apigoodslist", "fTags":tags, "currentPage":currentPage, "pageSize":20] as [String : Any]
            if self.type == .level2 {
                params["fCategoryid"] = categoryId
            }
            if fOrderbys != "" {
                params["fOrderby"] = fOrderbys
            }
            NetworkManager.requestPageInfoModel(params: params, success: { (bm: BaseModel<GoodsModel>) in
                self.tableView.endHeaderRefresh()
                self.tableView.endFooterRefresh()
                bm.whenSuccess {
                    if let list = bm.pageInfo?.list {
                        self.dealModels(list: list)
                    }
                    if !(bm.pageInfo?.hasNextPage ?? false) {
                        self.tableView.pullTORefreshControl.footer?.state = .noMoreData
                    }
                }
            }) { (err) in
                self.tableView.endHeaderRefresh()
                self.tableView.endFooterRefresh()
            }
        }
    }
    
    
    private func dealModels<T: CustomTableViewCellItem>(list: [T]) {
        var arr = list.map({ (model) -> T in
            model.build(heightForRow: 118)
            if self.type == .level2 {
                model.build(cellClass: GoodListLevel2Cell.self)
            } else {
                model.build(cellClass: GoodsCommonTableViewCell.self)
            }
            if let model = model as? PromotionModel {
                model.type = self.type
            } else if let model = model as? GoodsModel {
                model.type = self.type
            }
            
            model.setupCellAction { [unowned self] (idx) in
                let vc = Tools.getClassFromStorybord(sbName: Tools.StoryboardName.shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
                vc.type = self.type
                if let m = model as? GoodsModel {
                    if self.type == .level2 {
                        vc.type = .normal
                    }
                    vc.goodsId = m.fGoodsid
                } else if let model = model as? PromotionModel {
                    vc.promotionid = model.fPromotionid
                }
                
                
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return model
        })
        if self.currentPage > 1  {
            if self.tableView.dataArray.count > 0 {
                arr.insert(contentsOf: self.tableView.dataArray[0] as! [T], at: 0)
                self.tableView.dataArray = [arr]
            }
        }
        self.tableView.dataArray = [arr]
        self.tableView.reloadData()
    }
    
    
    func setupTabView() {
        headerView.lineTopMargin = 6
        var arr = [UIButton]()
        let titles = ["销量", "价格"]
        for title in titles {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            //239  47   53
            btn.setTitleColor(UIColor.hexStringToColor(hexString: "#ef2f35"), for: .selected)
            btn.setTitleColor(UIColor.hexStringToColor(hexString: "#ef2f35"), for: .normal)
            arr.append(btn)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            let iv = UIImageView(frame: CGRect(x: self.view.frame.width / CGFloat(titles.count) / 2 + 20, y: 5, width: 7, height: 14))
            iv.image = #imageLiteral(resourceName: "nosort")
            iv.tag = 1024
            btn.addSubview(iv)
            btn.tag = 0
        }
        
        headerView.showSeparator = true
        headerView.margin = 10
        //隐藏下面的横线
        headerView.bottomView.isHidden = true
        
        headerView.items = arr
        headerView.actions = { [unowned self] index in
            //do someThing
            var i = 0
            for btn in self.headerView.items {
                if let iv = btn.viewWithTag(1024) as? UIImageView {
                    iv.image = #imageLiteral(resourceName: "nosort")
                    if index == i {
                        btn.tag += 1
                        iv.image = (btn.tag & 1) == 0 ? #imageLiteral(resourceName: "up") : #imageLiteral(resourceName: "down")
                        if self.type != .normal && self.type != .level2 {
                            if index == 0 {
                                self.fOrderbys = (btn.tag & 1) == 0 ? "fSalescount asc" : "fSalescount desc"
                            } else {
                                self.fOrderbys = (btn.tag & 1) == 0 ? "fSalesprice asc" : "fSalesprice desc"
                            }
                        } else {
                            if index == 0 {
//                                self.fOrderbys = (btn.tag & 1) == 0 ? "fSalescount asc" : "fSalescount desc"
                            } else {
                                self.fOrderbys = (btn.tag & 1) == 0 ? "fSalesprice asc" : "fSalesprice desc"
                            }
                        }
                        self.tableView.beginHeaderRefresh()
                    } else {
                        btn.tag = 0
                    }
                }
                i += 1
            }
        }
    }

}
