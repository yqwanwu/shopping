//
//  FirstViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/11.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD
import SnapKit

class FirstViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    static let WELCOME_SHOWED = "WELCOME_SHOWED"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    
    lazy var refreshContrl: PullToRefreshControl = {
       return PullToRefreshControl(scrollView: self.collectionView).addDefaultHeader()
    } ()
    
    var secKillList = [PromotionModel]()
    var promotionList = [PromotionModel]()
    var groupList = [PromotionModel]()
    
    //广告数据
    var topAdsData = [BannerModel]()
    //商品数据
    var goodsList = [GoodsModel]()
    
    lazy var locationM: CLLocationManager = {//info.plist add :Privacy - Location Always Usage Description
        let locationM = CLLocationManager()
        locationM.delegate = self
        if #available(iOS 8.0, *) {
            locationM.requestAlwaysAuthorization()
        }
        return locationM
    }()
    
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    private var headerHeight = 400

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: FirstViewController.WELCOME_SHOWED)
        
        titleBack.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        titleBack.bounds.size.width = self.view.frame.width - 40
        searchBtn.layer.cornerRadius = 6
        
        RegionModel.requestData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: FirstGoodsCell.getNameString(), bundle: Bundle.main), forCellWithReuseIdentifier: FirstGoodsCell.getNameString())
        
        collectionView.backgroundColor = UIColor.hexStringToColor(hexString: "f0f0f0")
        collectionView.register(UINib(nibName: FirstSectionHeaderView.getNameString(), bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FirstSectionHeaderView.getNameString())
        
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.register(UINib(nibName: "FirstADSectionHeader", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FirstADSectionHeader")
        
        //添加刷新控件
        refreshContrl.header?.addAction(with: .refreshing, action: { [unowned self] _ in
            self.requestGoods()
            self.requestSecKill()
        }).beginRefresh()
        
        
        //MARK:一些初始化数据
        CarModel.requestList()
        
        if PersonMdel.isLogined() {
            MBProgressHUD.show()
            let p = PersonMdel.readData()!
            LoginVC.login(userName: p.fPhone, pwd: p.fUserpass, successAction: {
                MBProgressHUD.hideHUD()
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    //下方商品
    func requestGoods() {
        let params = ["method":"apigoodslist", "currentPage":"1", "pageSize":"16", "fRecommend":1] as [String:Any]
        NetworkManager.requestPageInfoModel(params: params)
            .setSuccessAction { (bm: BaseModel<GoodsModel>) in
                self.refreshContrl.endRefresh()
                self.goodsList = bm.pageInfo?.list ?? [GoodsModel]()
                self.collectionView.reloadData()
        }.seterrorAction { (err) in
            self.refreshContrl.endRefresh()
        }
    }
    
    ///请求秒杀
    func requestSecKill() {
        let params = ["method":"apipromotions", "fTypes":GoodsListVC.ListType.seckill.rawValue, "fStates":"0,1,2,3,4", "fSalestates":"1", "currentPage":1, "pageSize":6] as [String : Any]
        
        NetworkManager.requestPageInfoModel(params: params, success: { (bm: BaseModel<PromotionModel>) in
            bm.whenSuccess {
                let count = bm.pageInfo!.list!.count / 2 * 2
                if bm.pageInfo!.list!.count != count {
                    bm.pageInfo!.list!.removeLast()
                }
                self.secKillList = bm.pageInfo!.list!
                self.collectionView.reloadData()
            }
            self.reqeustOthers()
        }) { (err) in
            self.reqeustOthers()
        }
    }
    
    func reqeustOthers() {
        let params = ["method":"apipromotions", "fTypes":GoodsListVC.ListType.promotions.rawValue, "fStates":"0,1,2,3,4", "fSalestates":"1", "currentPage":1, "pageSize":6] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params, success: { (bm: BaseModel<PromotionModel>) in
            bm.whenSuccess {
                let count = bm.pageInfo!.list!.count / 2 * 2
                if bm.pageInfo!.list!.count != count {
                    bm.pageInfo!.list!.removeLast()
                }
                self.promotionList = bm.pageInfo!.list!
                self.collectionView.reloadData()
            }
        }) { (err) in
            
        }
        
        let params1 = ["method":"apipromotions", "fTypes":GoodsListVC.ListType.group.rawValue, "fStates":"0,1,2,3,4", "fSalestates":"1", "currentPage":1, "pageSize":6] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params1, success: { (bm: BaseModel<PromotionModel>) in
            bm.whenSuccess {
                let count = bm.pageInfo!.list!.count / 2 * 2
                if bm.pageInfo!.list!.count != count {
                    bm.pageInfo!.list!.removeLast()
                }
                self.groupList = bm.pageInfo!.list!
                self.collectionView.reloadData()
            }
        }) { (err) in
            
        }
    }
    
    
    @IBAction func ac_address(_ sender: Any) {
        let vc = Tools.getClassFromStorybord(sbName: .first, clazz: AddressVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 重写
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.titleBack.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleBack.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleBack.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    
    //MARK: 代理
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return self.secKillList.count
        } else if section == 2 {
            return self.groupList.count
        } else if section == 3 {
            return self.promotionList.count
        } else {
            return self.goodsList.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var commonCell: UICollectionViewCell!
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstHeaderCell.getNameString(), for: indexPath)
            
            if let cell = cell as? FirstHeaderCell {
                cell.topVC = self
                cell.requestADs() { [unowned self] _ in
                    self.collectionView.reloadData()
                }
            }
            commonCell = cell
        } else if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstGoodsCell.getNameString(), for: indexPath) as! FirstGoodsCell
            
            let model = goodsList[indexPath.row]
            cell.model = model
            commonCell = cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstGoodsCell.getNameString(), for: indexPath) as! FirstGoodsCell
            
            var model = PromotionModel()
            
            switch indexPath.section {
            case 1:
                model = secKillList[indexPath.row]
            case 2:
                model = groupList[indexPath.row]
            case 3:
                model = promotionList[indexPath.row]
            default:
                break
            }
            
            cell.promotionModel = model
            
            commonCell = cell
        }
        
        return commonCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let w = UIScreen.main.bounds.width
            let h = 200 + 15 + 152 / 375 * w //+ 11 / 75 * w
            return CGSize(width: UIScreen.main.bounds.width, height: h)
        } else {
            let w = UIScreen.main.bounds.width / 2 - 0.5
            return CGSize(width: w, height: 155)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FirstSectionHeaderView.getNameString(), for: indexPath) as! FirstSectionHeaderView
            var vc: UIViewController!
            var text = "团购"
            if indexPath.section == 1 {
                text = "秒杀"
                header.titleLabel.text = "秒杀"
                if let p = self.secKillList.first {
                    header.model = p
                }
                for label in header.subviews {
                    label.isHidden = false
                }
                vc = SecKillVC()
            } else {
                vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsListVC.self)
                let listVC = vc as! GoodsListVC
                switch indexPath.section {
                case 2:
                    listVC.type = .group
                case 3:
                    text = "促销"
                    listVC.type = .promotions
                case 4:
                    text = "推荐"
                default:
                    break
                }
                header.titleLabel.text = text
                for label in header.subviews {
                    if label is UILabel {
                        label.isHidden = true
                    }
                }
                header.titleLabel.isHidden = false
            }
            vc.title = text
            header.clickAction = { [unowned self] _ in
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FirstADSectionHeader", for: indexPath) as! FirstADSectionHeader
            footer.topVC = self
            var tag = 0
//            -100 首页上部 ,-101 首页中部,-102 首页下部,-200团购,-300秒杀,-400促销
            if indexPath.section == 0 {
                tag = -101
            } else if indexPath.section == 2 {
                tag = -102
            }
            
            if let data = FirstHeaderCell.banners.filter({$0.fPage == tag}).first {
                footer.imgView.sd_setImage(with: URL.encodeUrl(string: data.fPicurl), placeholderImage: #imageLiteral(resourceName: "placehoder"))
//                footer.tapAction = { [unowned self] _ in
//                    
//                }
                footer.urlStr = data.fLink
            }
            
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let w = UIScreen.main.bounds.width

        switch section {
        case 0:
            if let _ = FirstHeaderCell.banners.filter({$0.fPage == -101}).first {
                return CGSize(width: w, height: 11 / 75 * w)
            }
        case 3:
            if let _ = FirstHeaderCell.banners.filter({$0.fPage == -102}).first {
                return CGSize(width: w, height: 11 / 75 * w)
            }
        default:
            return CGSize.zero
        }
        return CGSize.zero
    }
    
    //header 高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        if section == 1 {
            return secKillList.isEmpty ? CGSize.zero : CGSize(width: self.view.frame.width, height: 50)
        } else if section == 2 {
            return groupList.isEmpty ? CGSize.zero : CGSize(width: self.view.frame.width, height: 50)
        } else if section == 3 {
            return promotionList.isEmpty ? CGSize.zero : CGSize(width: self.view.frame.width, height: 50)
        } else {
            return CGSize(width: self.view.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 && indexPath.section < 4  {
            var goods = PromotionModel()
            
            switch indexPath.section {
            case 1:
                goods = secKillList[indexPath.row]
            case 2:
                goods = groupList[indexPath.row]
            case 3:
                goods = promotionList[indexPath.row]
            default:
                break
            }
            
            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
            vc.promotionid = goods.fPromotionid
            vc.picUrl = goods.fUrl
            // 0:无 1:团购 2:秒杀 3:满减 4:买赠 5:多倍积分 6:折扣
            switch goods.fType {
            case 0:
                vc.type = .normal
            case 1:
                vc.type = .group
            case 2:
                vc.type = .seckill
            case 3, 4, 5, 6:
                vc.type = .promotions
            default:
                break
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 4 {
            let goods = goodsList[indexPath.row]
            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
            switch goods.fPromotiontype {
            case 0:
                vc.type = .normal
            case 1:
                vc.type = .group
            case 2:
                vc.type = .seckill
            case 3, 4, 5, 6:
                vc.type = .promotions
            default:
                break
            }
            vc.goodsId = goods.fGoodsid
            vc.picUrl = goods.fUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    //定位
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {return}
        //        print(newLocation)//<+31.26514482,+121.61259089> +/- 50.00m (speed 0.00 mps / course -1.00) @ 2016/11/14 中国标准时间 14:49:51
        if newLocation.horizontalAccuracy < 0 { return }
        geoCoder.reverseGeocodeLocation(newLocation) { (pls: [CLPlacemark]?, error: Error?) in
            if error == nil {
                guard let pl = pls?.first else {return}
                //                print(pl.name!)//金京路
                //                print(pl.locality!)//上海市
                var name = pl.locality ?? ""
                if name.substring(from: name.index(name.endIndex, offsetBy: -1)) == "市" {
                    name = name.substring(to: name.index(name.endIndex, offsetBy: -1))
                }
                self.addressBtn.setTitle(name, for: .normal)
            }
        }
        manager.stopUpdatingLocation()
    }
}

