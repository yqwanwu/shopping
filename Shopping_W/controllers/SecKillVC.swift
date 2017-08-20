//
//  SecKillVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/1.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class SecKillVC: BaseViewController {
    static func getAdHeight() -> CGFloat {
        return UIScreen.main.bounds.width * 11 / 75
    }
    lazy var tableView: RefreshTableView = {
        let t = RefreshTableView(frame: CGRect(x: 0, y: self.headerView.frame.maxY + 1, width: self.view.frame.width, height: self.view.frame.height - 71 - 64), style: .grouped)
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
        
        if let b = FirstHeaderCell.banners.filter({$0.fPage == -300}).first {
            self.headerView.frame.origin.y += SecKillVC.getAdHeight()
            let ad = UINib(nibName: "FirstADSectionHeader", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! FirstADSectionHeader
            ad.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: SecKillVC.getAdHeight())
            self.view.addSubview(ad)
            ad.imgView.sd_setImage(with: URL.encodeUrl(string: b.fPicurl))
            ad.topVC = self
            ad.urlStr = b.fLink
        }
        
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

        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["method":"apipromotionsforms"] as [String : Any]
        NetworkManager.requestListModel(params: params, success: { (bm: BaseModel<SecKillModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            self.tableView.endHeaderRefresh()
            self.tableView.endFooterRefresh()
            bm.whenSuccess {
                if let list = bm.list {
                    let arr = list.map({ (model) -> SecKillModel in
                        let _ = model.exList.map({ (model) -> SecKillExtModel in
                            model.build(heightForRow: 118)
                            model.build(cellClass: GoodsCommonTableViewCell.self)
                            
                            model.setupCellAction { [unowned self] (idx) in
                            let vc = Tools.getClassFromStorybord(sbName: Tools.StoryboardName.shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
                            vc.type = .seckill
                            vc.promotionid = model.fPromotionid
                            self.navigationController?.pushViewController(vc, animated: true)
                            }
                            return model
                        })
                        return model
                    })
                    
                    self.datas = arr
                    
                    self.tableView.dataArray = [arr[0].exList]
                    self.tableView.reloadData()
                    
                    //设置header
                    var btnArr = [UIButton]()
                    for m in arr {
                        let btn = SecKillBtn(type: .custom)
                        btn.setTitle(m.fDate, for: .normal)
                        btn.topLabel.text = m.fTime
                        btnArr.append(btn)
                        
                        btn.setTitleColor(UIColor.hexStringToColor(hexString: "888888"), for: .normal)
                    }
                    self.headerView.items = btnArr
                    self.headerView.layoutSubviews()
                    self.headerView.selectedIndex = 0
                }
                
            }
        }) { (err) in
            MBProgressHUD.hideHUD(forView: self.view)
        }
    }

    
    func setupTabView() {
        headerView.margin = 20
        
        headerView.showSeparator = true
        //隐藏下面的横线
        headerView.bottomView.isHidden = true
        headerView.backgroundColor = UIColor.white
        
        self.headerView.items = [UIButton]()
        
        headerView.actions = { [unowned self] index in
            self.tableView.dataArray = [self.datas[self.headerView.selectedIndex].exList]
            self.tableView.reloadData()
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
