//
//  GoodsDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class GoodsDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    
    
    var type = GoodsListVC.ListType.normal

    override func viewDidLoad() {
        super.viewDidLoad()
        //fdc249
        setupTypeView()
        setupCustomBk()
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

    
    //MARK: 代理
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
