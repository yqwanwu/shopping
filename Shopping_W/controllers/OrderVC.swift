//
//  OrderVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/17.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class OrderVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var headerView: TabView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let titles = ["全部订单", "待付款", "待发货", "待收货", "待评价"]
    
    enum OrderType: Int {
        case all = 0, pay, send, recive, evaluate, alreadyEvaluate
    }
    
    
    lazy var tableViewList: [RefreshTableView] = {
        var arr = [RefreshTableView]()
        
        for title in self.titles {
            let tableView = RefreshTableView(frame: CGRect.zero, style: .grouped)
            arr.append(tableView)
        }
        return arr
    } ()
    
    var loadedIndex: Int = 0
    
    var needChange = true
    
    var selectedIndex = 0 {
        didSet {
            if needChange {
                if selectedIndex < 5 && selectedIndex >= 0 {
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
            tableView.backgroundColor = UIColor.randColor()
            
            tableView.addHeaderAction {
                print("sdadsadas")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { 
                    tableView.endHeaderRefresh()
                })
            }
            
            tableView.autoLoadWhenIsBottom = false
            
            tableView.addFooterAction {
                print("aaaaaaaaa")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    tableView.endFooterRefresh()
                })
            }
            
            tableView.dataSource = self
            
            //MARK: 假数据
            let c = OrderModel().build(cellClass: OrerListCell.self).build(heightForRow: 118)
            c.type = OrderType(rawValue: i)!
            
            c.setupCellAction({ [unowned self] (idx) in
                let vc = OrderDetailVC()
                
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
            tableView.dataArray = [[c, c, c, c]]
            
            i += 1
        }
        
        selectedIndex += 0
        tableViewList[selectedIndex].beginHeaderRefresh()
        loadedIndex = loadedIndex | (1 << selectedIndex)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadData(index: Int? = nil) {
        let si = index ?? selectedIndex
        if loadedIndex & (1 << si) == 0 {
            tableViewList[si].beginHeaderRefresh()
            loadedIndex = loadedIndex | (1 << si)
        }
        self.title = self.titles[si]
        
        for btn in headerView.items {
            btn.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let w = self.view.frame.width
        var i: CGFloat = 0.0
        for tableView in tableViewList {
            tableView.frame = CGRect(x: i * w, y: 0, width: w, height: self.scrollView.frame.height - 100)
            i += 1
        }
    }
    
    func selectTablevie() {
        let progress = scrollView.contentOffset.x / view.frame.width
        headerView.selectedIndex = Int(progress + 0.1)
        selectedIndex = headerView.selectedIndex
        loadData()
    }
    
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = (tableView as! RefreshTableView).dataArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: OrerListCell.getNameString(), for: indexPath) as! OrerListCell
        cell.model = data
        
        cell.logisticsAction = { [unowned self] _ in
            print("adasd")
        }
        
        cell.reciveAction = { [unowned self] _ in
            print("213213")
        }
        
        return cell
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

















