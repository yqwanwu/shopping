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
    
    var type = ListType.normal

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c = GoodsListModel().build(heightForRow: 118)
        
        if type == .level2 {
            c.build(cellClass: GoodListLevel2Cell.self)
        } else {
            c.build(cellClass: GoodsCommonTableViewCell.self)
        }
        c.type = type
        c.setupCellAction { [unowned self] (idx) in
            let vc = Tools.getClassFromStorybord(sbName: Tools.StoryboardName.shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
            vc.type = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.dataArray = [[c, c, c, c]]
        
        setupTabView()
        
        requestPromotions()
    }
    
    ///促销列表
    func requestPromotions() {
        let params = ["method":"apipromotions", "fTypes":type.rawValue, "fStates":"0,1,2,3,4", "fSalestates":"0,1,2", "currentPage":1, "pageSize":20] as [String : Any]
        
        NetworkManager.requestPageInfoModel(params: params, success: { (bm: BaseModel<PromotionModel>) in
            bm.whenSuccess {
                
            }
        }) { (err) in
            
        }
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
            
            let iv = UIImageView(frame: CGRect(x: self.view.frame.width / CGFloat(titles.count) / 2 + 20, y: 5, width: 24, height: 24))
            iv.image = #imageLiteral(resourceName: "sort")
            btn.addSubview(iv)
        }
        
        headerView.showSeparator = true
        headerView.margin = 10
        //隐藏下面的横线
        headerView.bottomView.isHidden = true
        
        headerView.items = arr
        headerView.actions = { [unowned self] index in
            //do someThing
            
        }
    }

}
