//
//  ViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/16.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage

class ViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UIPopoverPresentationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var carouselView: CarouselCollectionView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var adImgView: UIImageView!
    
    @IBOutlet weak var tableView: RefreshTableView!
    
    var topAdsData = [BannerModel]()
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleBack.bounds.size.width = self.view.frame.width - 40
        searchBtn.layer.cornerRadius = 6
        
        let top: CGFloat = CGFloat(200 - 70 * 2) / 3
        let left = (self.view.frame.width - 80.0 * 4) / 5
        itemCollectionView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
        
        let c1 = CustomTableViewCellItem().build(cellClass: FirstGridTableViewCell.self).build(heightForRow: 268)
        let c2 = CustomTableViewCellItem().build(cellClass: FirstFlowTableViewCell.self).build(heightForRow: 210)
        tableView.dataArray = [[c1, c2, c2, c1]]
        
        locationM.startUpdatingLocation()
        
        requestGoods()
        requestADs()
    }
    
    //下方商品
    func requestGoods() {
        let params = ["method":"apigoodslist", "currentPage":"1", "pageSize":"20"] as [String:Any]
        NetworkManager.requestPageInfoModel(params: params)
            .setSuccessAction { (bm: BaseModel<GoodsModel>) in
            
        }
    }
    
    func requestADs() {
        NetworkManager.requestListModel(params: ["method":"apibannerlist"])
            .setSuccessAction { (bm: BaseModel<BannerModel>) in
                self.topAdsData.removeAll()
                for banner in bm.list! {
                    if banner.fPage == -100 {
                        self.topAdsData.append(banner)
                    } else if banner.fPage == -101 {
                        self.adImgView.sd_setImage(with: URL.encodeUrl(string: banner.fPicurl), placeholderImage: #imageLiteral(resourceName: "placehoder"))
                    }
                }
                self.carouselView.reloadData()
        }
    }
    
    
    @IBAction func ac_address(_ sender: Any) {
        let vc = Tools.getClassFromStorybord(sbName: .first, clazz: AddressVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ac_adTap(_ sender: UITapGestureRecognizer) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeader.frame.size.height = adImgView.frame.maxY
        tableView.tableHeaderView = tableHeader
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? AddressSelectVC {
//            vc.modalPresentationStyle = .popover
//            vc.preferredContentSize = CGSize(width: 200, height: 300)
//            vc.popoverPresentationController?.delegate = self
//            vc.topVC = self
//        }
    }
    
    //MARK: 代理 
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselView {
            return topAdsData.count
        }
        return FirstItem.defaultDatas.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == carouselView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCollectionViewCell
            let data = topAdsData[self.carouselView.realCurrentIndexPath.row]
            cell.imageView.sd_setImage(with: URL.encodeUrl(string: data.fPicurl), placeholderImage: #imageLiteral(resourceName: "placehoder"))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FirstItemCollectionViewCell
            cell.imgView.image = UIImage(named: FirstItem.defaultDatas[indexPath.row].imgName)
            cell.titleLabel.text = FirstItem.defaultDatas[indexPath.row].title
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == carouselView {
            return 0
        }
        return (self.view.frame.width - 80.0 * 4) / 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == carouselView {
            //MARK: 必须用 realCurrentIndexPath才是准确的
            print(carouselView.realCurrentIndexPath)
        } else {
            let data = FirstItem.defaultDatas[indexPath.row]
            
            if data.title == "全部分类" {
                self.tabBarController?.selectedIndex = 1
            } else {
                var vc: UIViewController!
                if data.title == "秒杀" {
                    vc = SecKillVC()
                } else {
                    vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsListVC.self)
                    let listVC = vc as! GoodsListVC
                    let t = FirstItem.defaultDatas[indexPath.row].title
                    if t == "促销" {
                        listVC.type = .promotions
                    } else if t == "团购" {
                        listVC.type = .group
                    }
                    vc.title = data.title
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
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

