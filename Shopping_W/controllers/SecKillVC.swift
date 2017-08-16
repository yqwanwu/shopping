//
//  SecKillVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/1.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SecKillVC: BaseViewController {
    
    lazy var tableView: RefreshTableView = {
        let t = RefreshTableView(frame: CGRect(x: 0, y: 71 + 64, width: self.view.frame.width, height: self.view.frame.height - 71 - 64), style: .grouped)
        t.separatorInset.left = 0
        return t
    } ()
 
    lazy var headerView: TabView = {
        let t = TabView(frame: CGRect(x: 0, y: 10 + 64, width: self.view.frame.width, height: 60))
        return t
    } ()
    
    var datas = [SecKillModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        
        self.view.addSubview(headerView)
        setupTabView()
        
        self.title = "秒杀"
        requestData()
    }
    
    func requestData() {
//        method	string	apipromotionsforms	无
//        fShopid	number	自行获取	商店ID
//        fCategoryid	number	自行获取	分类ID
//        fStates	string	自行获取	0未开始 1 进行中 2待发货 3已发货 4未成团 5已退款,多个用逗号分割
//        fSalestates	string	自行获取	0未上架 1 已上架 2 自动下架，多个逗号分割
//        fOrderbys	string	自行录入	排序字段 多个逗号分割 如 fSalesprice desc,fPurchasecount asc

        
        let params = ["method":"apipromotionsforms", "fSalestates":"1"] as [String : Any]
        
        NetworkManager.requestListModel(params: params, success: { (bm: BaseModel<SecKillModel>) in
            self.tableView.endHeaderRefresh()
            self.tableView.endFooterRefresh()
            bm.whenSuccess {
                if let list = bm.list {
                    self.datas = list
                    
                    let arr = list.map({ (model) -> SecKillModel in
                        let _ = model.exList.map({ (model) -> SecKillExtModel in
                            model.build(heightForRow: 118)
                            model.build(cellClass: GoodsCommonTableViewCell.self)
                            
                            model.setupCellAction { [unowned self] (idx) in
                            let vc = Tools.getClassFromStorybord(sbName: Tools.StoryboardName.shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
                            vc.type = .seckill
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            }
                            return model
                        })
                        return model
                    })
                    self.tableView.dataArray = [arr[self.headerView.selectedIndex].exList]
                    self.tableView.reloadData()
                }
                
            }
        }) { (err) in
            
        }
    }

    
    func setupTabView() {
        var arr = [UIButton]()
        let titles = ["请购中asdasd", "即将开始", "即将开始", "即将开始", "即将开始", "即将开始", "即将开始"]
        for title in titles {
            let btn = SecKillBtn(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.topLabel.text = "测试下下"
            arr.append(btn)
            
            btn.setTitleColor(UIColor.hexStringToColor(hexString: "888888"), for: .normal)
        }
        
        headerView.margin = 20
        
        headerView.showSeparator = true
        //隐藏下面的横线
        headerView.bottomView.isHidden = true
        headerView.backgroundColor = UIColor.white
        headerView.items = arr
        headerView.actions = { [unowned self] index in
            //do someThing
            
        }
        
        //添加 半透明遮罩
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: headerView.frame.width - 60, y: 0, width: 60, height: 60)
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [UIColor(white: 1, alpha: 0.3).cgColor, UIColor(white: 1, alpha: 0.95).cgColor]
        headerView.layer.addSublayer(layer)
    }
    
    private class SecKillBtn: UIButton {
        let margin: CGFloat = 10
        
        override var isSelected: Bool {
            didSet {
                topLabel.textColor = isSelected ? UIColor.hexStringToColor(hexString: "ef2f35") : UIColor.black
            }
        }
        
        lazy var topLabel: UILabel = {
            let l = UILabel(frame: CGRect(x: 0, y: self.margin, width: self.frame.width, height: 20))
            l.textAlignment = .center
            l.font = UIFont.systemFont(ofSize: 14)
            return l
        } ()
        
        func setup() {
            self.addSubview(topLabel)
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
            return CGRect(x: 0, y: self.frame.height - margin - 14, width: self.frame.width, height: 14)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            topLabel.frame = CGRect(x: 0, y: self.margin, width: self.frame.width, height: 20)
        }
    }
}
