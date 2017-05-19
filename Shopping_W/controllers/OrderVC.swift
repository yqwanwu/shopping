//
//  OrderVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/17.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class OrderVC: BaseViewController {
    @IBOutlet weak var headerView: TabView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let titles = ["全部订单", "待付款", "待发货", "待收货", "待评价"]
    
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
        
    }
    
    
    func setupHeader() {
        scrollView.contentSize = CGSize(width: 5 * self.view.frame.width, height: 0)
        var arr = [UIButton]()
        
        for title in titles {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
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
            self.selectedIndex = index
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.scrollView.contentOffset.x = CGFloat(index) * UIScreen.main.bounds.width
            }, completion: { (finish) in
                
            })
        }
    }
    
    func setupTableView() {
        for tableView in tableViewList {
            self.scrollView.addSubview(tableView)
            tableView.backgroundColor = UIColor.randColor()
            
            let c = CustomTableViewCellItem()
                .build(text: "qweqwe")
                .build(cellClass: CustomTableViewCell.self)
                .build(heightForRow: 100)
            tableView.dataArray = [[c, c]]
            
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
}

















