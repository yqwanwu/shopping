//
//  FirstViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/11.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    
    lazy var refreshContrl: PullToRefreshControl = {
       return PullToRefreshControl(scrollView: self.collectionView).addDefaultHeader()
    } ()
    
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
        
        //添加刷新控件
        refreshContrl.header?.addAction(with: .refreshing, action: { [unowned self] _ in
            self.requestGoods()
        }).beginRefresh()
    }
    
    //下方商品
    func requestGoods() {
        let params = ["method":"apigoodslist", "currentPage":"1", "pageSize":"20"] as [String:Any]
        NetworkManager.requestPageInfoModel(params: params)
            .setSuccessAction { (bm: BaseModel<GoodsModel>) in
                self.refreshContrl.endRefresh()
                self.goodsList = bm.pageInfo?.list ?? [GoodsModel]()
                self.collectionView.reloadData()
        }.seterrorAction { (err) in
            self.refreshContrl.endRefresh()
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
    
    
    //MARK: 代理
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.goodsList.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var commonCell: UICollectionViewCell!
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstHeaderCell.getNameString(), for: indexPath)
            
            if let cell = cell as? FirstHeaderCell {
                cell.topVC = self
                cell.requestADs()
            }
            commonCell = cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstGoodsCell.getNameString(), for: indexPath) as! FirstGoodsCell
            
            let model = goodsList[indexPath.row]
            cell.model = model
            
            commonCell = cell
        }
        
        return commonCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let w = UIScreen.main.bounds.width
            let h = 200 + 15 + 152 / 375 * w + 11 / 75 * w
            return CGSize(width: UIScreen.main.bounds.width, height: h)
        } else {
            let w = UIScreen.main.bounds.width / 2 - 0.5
            return CGSize(width: w, height: 155)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FirstSectionHeaderView.getNameString(), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: self.view.frame.width, height: 50)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section >= 1 {
            let goods = goodsList[indexPath.row]
            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
            vc.goodsId = goods.fGoodsid
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
