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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        
        let c = CustomTableViewCellItem().build(cellClass: GoodsCommonTableViewCell.self).build(heightForRow: 118)
        c.setupCellAction { [unowned self] (idx) in
            let vc = Tools.getClassFromStorybord(sbName: Tools.StoryboardName.shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
            vc.type = .seckill
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.dataArray = [[c, c, c, c]]
        
        self.view.addSubview(headerView)
        setupTabView()
        
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
