//
//  GoodsListVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/1.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class GoodsListVC: BaseViewController {
    @IBOutlet weak var tableView: RefreshTableView!
    @IBOutlet weak var headerView: TabView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    enum ListType: String {
        ///   二级页面  团购   秒杀      一般的   促销   推荐
        case level2, group = "1", seckill = "2", normal, promotions = "3,4,5,6", recommend
    }
    
    var tags = ""
    var currentPage = 1
    
    var type = ListType.normal
    
    var fOrderbys = ""
    var categoryId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        var tag = 0
        if self.type == .group {
            tag = -200
            //后面的界面改了，，，
            setupTabView()
        } else if self.type == .promotions {
            tag = -400
            setupPromotionsTab()
            tableViewTop.constant = 1
        }
        
        if tag != 0 {
            if let b = FirstHeaderCell.banners.filter({$0.fPage == tag}).first {
                self.headerView.frame.origin.y += SecKillVC.getAdHeight()
                let ad = UINib(nibName: "FirstADSectionHeader", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! FirstADSectionHeader
                ad.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: SecKillVC.getAdHeight())
                self.view.addSubview(ad)
                ad.imgView.sd_setImage(with: URL.encodeUrl(string: b.fPicurl))
                ad.topVC = self
                ad.urlStr = b.fLink
                self.headerHeight.constant = 10 + SecKillVC.getAdHeight()
            }
        }
        
        
        
        self.tableView.addFooterAction { [unowned self] _ in
            self.currentPage += 1
            if self.type == .promotions {
                self.requestPromotions(types: "\(self.headerView.selectedIndex + 3)")
            } else {
                self.requestPromotions()
            }
            
        }
        
        self.tableView.addHeaderAction { [unowned self] _ in
            self.currentPage = 1
            if self.type == .promotions {
                self.requestPromotions(types: "\(self.headerView.selectedIndex + 3)")
            } else {
                self.requestPromotions()
            }
        }
        self.tableView.beginHeaderRefresh()
    }
    
    //促销界面
    func setupPromotionsTab() {
        headerView.lineTopMargin = 6
        var arr = [UIButton]()
        let titles = ["满减", "多倍积分", "买赠", "折扣"]
        for title in titles {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            //239  47   53
            btn.setTitleColor(CustomValue.common_red, for: .selected)
            btn.setTitleColor(UIColor.black, for: .normal)
            arr.append(btn)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            btn.tag = 0
        }
        
        headerView.showSeparator = true
        headerView.margin = 10
        //隐藏下面的横线
//        headerView.bottomView.isHidden = true
        headerView.items = arr
        
        headerView.actions = { [unowned self] index in
            self.requestPromotions(types: "\(index + 3)", showHUD: true)
        }
    }
    
    ///促销列表
    func requestPromotions(types: String? = nil, showHUD: Bool = false) {
        if type != .normal && type != .level2 && type != .recommend {
            var params = ["method":"apipromotions", "fTypes": types ?? type.rawValue, "fStates":"0,1,2,3,4", "fSalestates":"0,1,2", "currentPage":currentPage, "pageSize":20] as [String : Any]
            if fOrderbys != "" {
                params["fOrderby"] = fOrderbys
            }
            
            if showHUD {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            NetworkManager.requestPageInfoModel(params: params, success: { (bm: BaseModel<PromotionModel>) in
                MBProgressHUD.hideHUD(forView: self.view)
                self.tableView.endHeaderRefresh()
                self.tableView.endFooterRefresh()
                bm.whenSuccess {
                    if let list = bm.pageInfo?.list {
                        self.dealModels(list: list)
                    }
                    if !(bm.pageInfo?.hasNextPage ?? false) {
                        self.tableView.pullTORefreshControl.footer?.state = .noMoreData
                    }
                    self.tableView.reloadData()
                }
            }) { (err) in
                
            }
        } else {
            var params = ["method":"apigoodslist", "fTags":tags, "currentPage":currentPage, "pageSize":20] as [String : Any]
            if self.type == .level2 {
                params["fCategoryid"] = categoryId
            } else if type == .recommend {
                params["fRecommend"] = "1"
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
                    self.tableView.reloadData()
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
                    vc.picUrl = m.fUrl
                    vc.goodsId = m.fGoodsid
                } else if let model = model as? PromotionModel {
                    vc.promotionid = model.fPromotionid
                    vc.picUrl = model.fUrl
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
                                self.fOrderbys = (btn.tag & 1) == 0 ? "fSalescount asc" : "fSalescount desc"
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
