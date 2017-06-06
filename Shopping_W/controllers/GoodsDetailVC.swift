//
//  GoodsDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class GoodsDetailVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var scrollBk: UIScrollView!
    @IBOutlet weak var carouselView: CarouselCollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countBtn: CalculateBtn!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var typeBk: UIView!
    
    
    //标记而已
    @IBOutlet weak var typeBkFirstItem: UILabel!
    
    ///promotions
    @IBOutlet weak var promotionsBk: UIView!
    @IBOutlet weak var promotionsLabel: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    
    ///seckill
    @IBOutlet weak var seckillBk: UIView!
    @IBOutlet weak var seckilltime: UILabel!
    @IBOutlet weak var seckillNumber: UILabel!
    @IBOutlet weak var seckillLastTime: UILabel!
    
    ///group
    @IBOutlet weak var groupStartTime: UILabel!
    //团购结束时间：2017-3-30
    @IBOutlet weak var groupEndTime: UILabel!
    //总数量：10000
    @IBOutlet weak var groupNUmber: UILabel!
    //剩余时间：1231
    @IBOutlet weak var groupLaseTime: UILabel!
    @IBOutlet weak var groupBk: UIView!
    @IBOutlet weak var rightItem: UIBarButtonItem!
    
    //底部
    @IBOutlet weak var carBtn: CustomTabBarItem!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var serverbtn: CustomTabBarItem!
    @IBOutlet weak var bottomBk: UIView!
    
    //评分
    @IBOutlet weak var starView: StarMarkView!
    
    @IBOutlet weak var evaluateCountLabel: UILabel!
    
    
    var type = GoodsListVC.ListType.normal
    @IBOutlet weak var tableView: CustomTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //fdc249
        setupTypeView()
        setupCustomBk()
        
        starView.sadImg = #imageLiteral(resourceName: "p4.6.1.1-评价-灰.png")
        starView.likeImg = #imageLiteral(resourceName: "p4.6.1.1-评价-红.png")
        starView.margin = 5
        
        carBtn.setTitleColor(UIColor.hexStringToColor(hexString: "888888"), for: .normal)
        carBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        carBtn.badgeValue = "21"
        serverbtn.setTitleColor(UIColor.hexStringToColor(hexString: "888888"), for: .normal)
        serverbtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        let c = CustomTableViewCellItem().build(cellClass: EvaluateCell.self)
        tableView.dataArray = [[c, c, c]]
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setupCustomBk() {
        var promotionsH: CGFloat = 0//45
        var seckillH: CGFloat = 0//70
        var groupH: CGFloat = 0//73
        
        if type == .normal {
            
        } else if type == .promotions {//促销
            promotionsH = 45
        } else if type == .seckill { // 秒杀
            seckillH = 70
        } else if type == .group { // 团购
            groupH = 73
        }
        
        if promotionsH == 0 {
            promotionsBk.isHidden = true
        }
        
        if seckillH == 0 {
            seckillBk.isHidden = true
        }
        
        if groupH == 0 {
            groupBk.isHidden = true
        }
        
        promotionsBk.snp.updateConstraints { (make) in
            make.height.equalTo(promotionsH)
        }
        seckillBk.snp.updateConstraints { (make) in
            make.height.equalTo(seckillH)
        }
        groupBk.snp.updateConstraints { (make) in
            make.height.equalTo(groupH)
        }
    }
    
    func setupTypeView() {
        var currentView: UIView = typeBkFirstItem
        for i in 0..<3 {
            let currentBtn = UIButton(type: .system)
            currentBtn.setTitle("\(i)个", for: .normal)
            currentBtn.setTitleColor(UIColor.hexStringToColor(hexString: "fdc249"), for: .normal)
            currentBtn.setTitleColor(CustomValue.common_red, for: .highlighted)
            currentBtn.layer.cornerRadius = 4
            currentBtn.layer.borderColor = UIColor.hexStringToColor(hexString: "fdc249").cgColor
            currentBtn.layer.borderWidth = 1
            
            typeBk.addSubview(currentBtn)
            
            currentBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(currentView)
                make.width.equalTo(50)
                make.height.equalTo(25)
                make.left.equalTo(currentView.snp.right).offset(20)
            })
            
            currentView = currentBtn
        }
    }
    
    
    //MARK: 底部点击事件
    
    @IBAction func ac_shopingCar(_ sender: CustomTabBarItem) {
        CustomTabBarVC.instance.selectToFirst(index: 2)
    }
    @IBAction func ac_server(_ sender: CustomTabBarItem) {
    }
    @IBAction func ac_add(_ sender: UIButton) {
    }
    
    
    @IBAction func ac_right(_ sender: UIBarButtonItem) {
        
    }
    
    
    //重写
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollBk.contentSize.height = tableView.frame.maxY
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            let vc = segue.destination
            
            vc.view.backgroundColor = UIColor.red
            vc.modalPresentationStyle = .popover
            vc.popoverPresentationController?.delegate = self
            vc.preferredContentSize = CGSize(width: 140, height: 100)
        }
    }

    
    //MARK: 代理
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselView {
            return 3
        }
        return FirstItem.defaultDatas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCollectionViewCell
        cell.imageView.image = #imageLiteral(resourceName: "placehoder")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == carouselView {
            //MARK: 必须用 realCurrentIndexPath才是准确的
            print(carouselView.realCurrentIndexPath)
        }
        
    }
    
}
