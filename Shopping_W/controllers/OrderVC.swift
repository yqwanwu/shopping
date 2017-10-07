//
//  OrderVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/17.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderTableView: RefreshTableView {
    var currentPage = 1
    
}

class OrderVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var headerView: TabView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let k_toEvaluateVC = "toEvaluateVC"
    let k_Logistics = "toLogistics"
    
    private let titles = ["全部订单", "待付款", "待发货", "待收货", "待评价"]
    
    enum OrderType: Int {
        case all = 0, pay, send, recive, evaluate, alreadyEvaluate, myEvaluate, myCollection, cookies, /*换货*/returned, /*换货中*/returning
    }
    
    
    lazy var tableViewList: [OrderTableView] = {
        var arr = [OrderTableView]()
        
        for title in self.titles {
            let tableView = OrderTableView(frame: CGRect.zero, style: .grouped)
            arr.append(tableView)
        }
        return arr
    } ()
    
    var loadedIndex: Int = 0
    
    var needChange = true
    //刷新全部
    static var needUpdate = false
    
    var selectedIndex = 0 {
        didSet {
            if needChange && self.scrollView != nil {
                if selectedIndex < 5 && selectedIndex >= 0 {
                    headerView.selectedIndex = selectedIndex
                    self.scrollView.contentOffset.x = CGFloat(selectedIndex) * UIScreen.main.bounds.width
                }
            }
            needChange = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
        setupTableView()
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
    }
    
    
    func setupHeader() {
        scrollView.contentSize = CGSize(width: 5 * self.view.frame.width, height: 0)
        var arr = [UIButton]()
        
        for title in titles {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            //239  47   53
            btn.setTitleColor(UIColor.hexStringToColor(hexString: "#ef2f35"), for: .selected)
            btn.setTitleColor(UIColor.black, for: .normal)
            arr.append(btn)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        headerView.showSeparator = true
        headerView.margin = 10
        //隐藏下面的横线
        headerView.bottomView.isHidden = true
        
        headerView.items = arr
        headerView.actions = { [unowned self] index in
            self.title = self.titles[self.selectedIndex]
            self.selectedIndex = index
            self.loadData(index: index)
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.scrollView.contentOffset.x = CGFloat(index) * UIScreen.main.bounds.width
            }, completion: { (finish) in
                
            })
        }
        
        headerView.selectedIndex = selectedIndex
        self.title = self.titles[selectedIndex]
    }
    
    func setupTableView() {
        var i = 0
        for tableView in tableViewList {
            self.scrollView.addSubview(tableView)
            
            let index = i
            tableView.addHeaderAction { [unowned self] _ in
                tableView.currentPage = 1
                self.loadData(index: index, byPull: true)
            }
            
            tableView.autoLoadWhenIsBottom = false
            
            tableView.addFooterAction { [unowned self] _ in
                tableView.currentPage += 1
                self.loadData(index: index, byPull: true)
            }
            
            tableView.dataSource = self
            
            i += 1
        }
        
        selectedIndex += 0
        tableViewList[selectedIndex].beginHeaderRefresh()
        loadedIndex = loadedIndex | (1 << selectedIndex)
    }
    
    func loadData(index: Int? = nil, byPull: Bool = false) {
        let si = index ?? selectedIndex
        if loadedIndex & (1 << si) == 0 || byPull {//没有请求过 或者 拉动刷新控件
//            tableViewList[si].beginHeaderRefresh()
            loadedIndex = loadedIndex | (1 << si)
//            method	string	apiorders	无
//            fState	string	订单状态	0待付款 1已付款 2待发货 3已发货 4完成 5关闭,多个用逗号分割
            var state = "0"
            switch si {
            case 0:
                state = "0,1,2,3,4"
            case 2:
                state = "1,2"
            case 3:
                state = "3"
            case 4:
                state = "4"
            default:
                break
            }
            
            let tableView = tableViewList[si]
            //
            let method = si != 4 ? "apiorders" : "apigetPendingevaluationOrder"
            NetworkManager.requestPageInfoModel(params: ["method":method, "fState":state, "currentPage":tableView.currentPage, "pageSize":CustomValue.pageSize]).setSuccessAction(action: { (bm: BaseModel<OrderModel>) in
                tableView.endFooterRefresh()
                tableView.endHeaderRefresh()
                bm.whenSuccess {
                    if !bm.pageInfo!.hasNextPage {
                        tableView.noMoreData()
                    }
                    let arr = bm.pageInfo!.list!.map({ (c) -> OrderModel in
                        
                        var type = OrderType.pay
                        // 0待付款 1已付款 2待发货 3已发货 4完成 5关闭 send, recive, evaluate, alreadyEvaluate, myEvaluate, myCollection, cookies, /*换货*/returned, /*换货中*/returning
                        switch c.fState {
                        case 0:
                            type = .pay
                        case 1, 2:
                            type = .send
                        case 3:
                            type = .recive
                        case 4:
                            type = .evaluate
                        default:
                            break
                        }
                        
                        c.build(cellClass: OrerListCell.self).build(heightForRow: 118)
                        c.type = type
                        
                        c.setupCellAction({ [unowned self] (idx) in
                            let vc = OrderDetailVC()
                            vc.orderModel = c
                            if let data = tableView.dataArray[idx.section][idx.row] as? OrderModel {
                                vc.showPayBtn = data.type == .pay
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                        return c
                    })
                    if tableView.currentPage == 1 {
                        tableView.dataArray = [arr]
                    } else {
                        var oldArr = tableView.dataArray[0] as! [OrderModel]
                        oldArr.append(contentsOf: arr)
                        tableView.dataArray = [oldArr]
                    }
                    
                    tableView.reloadData()
                }
                
            })
        }
        self.title = self.titles[si]
        
        for btn in headerView.items {
            btn.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    //MARK: 重写
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if OrderVC.needUpdate {
            self.loadedIndex = 0
            self.loadData()
        }
        OrderVC.needUpdate = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let w = self.view.frame.width
        var i: CGFloat = 0.0
        for tableView in tableViewList {
            tableView.frame = CGRect(x: i * w, y: 0, width: w, height: self.scrollView.frame.height)
            i += 1
        }
    }
    
    func selectTablevie() {
        let progress = scrollView.contentOffset.x / view.frame.width
        headerView.selectedIndex = Int(progress + 0.1)
        selectedIndex = headerView.selectedIndex
        loadData(byPull: true)
    }
    
    func cancleOrder(orderId: Int) {
        NetworkManager.requestTModel(params: ["method":"apicancelorder", "fOrderid":orderId]).setSuccessAction { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                self.loadedIndex &= ~3
                self.loadData()
            }
        }
    }
    
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = (tableView as! RefreshTableView).dataArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: OrerListCell.getNameString(), for: indexPath) as! OrerListCell
        cell.model = data
        
        cell.logisticsAction = { [unowned self] _ in
            if let model = data as? OrderModel {
                if model.type == .recive {
                    self.performSegue(withIdentifier: self.k_Logistics, sender: self)
                } else if model.type == .pay {
                    self.cancleOrder(orderId: model.fOrderid)
                }
            }
        }
        
        cell.reciveAction = { [unowned self] _ in
            if let model = data as? OrderModel {
                if model.type == .evaluate {
//                    self.performSegue(withIdentifier: self.k_toEvaluateVC, sender: self)
                    let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: MyEvaluateVC.self) as! MyEvaluateVC
                    vc.orderModel = model
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if model.type == OrderType.recive {
                    let alert = AlertVC()
                    self.present(alert, animated: true, completion: nil)
                } else if model.type == .send {
                    MBProgressHUD.show(successText: "已提醒卖家尽快发货")
                } else if model.type == .pay {
                    let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: PayWayVC.self) as! PayWayVC
                    vc.orderModel = model
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UITableView {
            return
        }
        let progress = scrollView.contentOffset.x / view.frame.width
        
        let offset = progress - CGFloat(selectedIndex)
        if offset != 0 {
            let nextIndex = selectedIndex + (offset > 0 ? 1 : -1)
            
            let nextBtn = headerView.items[nextIndex]
            let currentBtn = headerView.items[selectedIndex]
            
            //239  47   53
            let persent = abs(offset)
            nextBtn.setTitleColor(UIColor(red: 239.0 / 255.0 * persent, green: 47.0 / 255.0 * persent, blue: 53.0 / 255.0 * persent, alpha: 1), for: .normal)
            currentBtn.setTitleColor(UIColor(red: 239.0 / 255.0 * (1 - persent), green: 47.0 / 255.0 * (1 - persent), blue: 53.0 / 255.0 * (1 - persent), alpha: 1), for: .normal)
        }
        
        if self.selectedIndex != headerView.selectedIndex {
            needChange = false
            self.selectedIndex = headerView.selectedIndex
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectTablevie()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        selectTablevie()
    }
}

















