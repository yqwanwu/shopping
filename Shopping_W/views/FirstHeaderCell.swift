//
//  FirstHeaderCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/11.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class FirstHeaderCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var adImgView: UIImageView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var carouselView: CarouselCollectionView!
    
    var topAdsData = [BannerModel]()
    weak var topVC: FirstViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adImgView.backgroundColor = UIColor.red
        carouselView.delegate = self
        carouselView.dataSource = self
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        let top: CGFloat = CGFloat(200 - 70 * 2) / 3
        let left = (UIScreen.main.bounds.width - 80.0 * 4) / 5
        itemCollectionView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
        
        requesIndexLabel()
    }
    
    func requesIndexLabel() {
        NetworkManager.requestListModel(params: ["method":"apiindexlabels"]).setSuccessAction { (bm: BaseModel<FirstItem>) in
            bm.whenSuccess {
                let list = bm.list!
                if !list.isEmpty {
                    FirstItem.defaultDatas.insert(list, at: 0)
                } else {
                    var arr = [FirstItem]()
                    arr.append(FirstItem(title: "健康中国", imgName: "健康"))
                    arr.append(FirstItem(title: "特色中国", imgName: "特色中国"))
                    arr.append(FirstItem(title: "清真专区", imgName: "清真专区"))
                    arr.append(FirstItem(title: "绿色中国", imgName: "绿色专区"))
                    FirstItem.defaultDatas.insert(arr, at: 0)
                }
                self.itemCollectionView.reloadData()
            }
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
    
    //MARK: 代理
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == carouselView {
            return 1
        }
        return FirstItem.defaultDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselView {
            return topAdsData.count
        }
        return FirstItem.defaultDatas[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == carouselView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCollectionViewCell
            let data = topAdsData[indexPath.row]
            print(self.carouselView.realCurrentIndexPath.row)
            cell.imageView.sd_setImage(with: URL.encodeUrl(string: data.fPicurl), placeholderImage: #imageLiteral(resourceName: "placehoder"))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FirstItemCollectionViewCell
            cell.imgView.image = UIImage(named: FirstItem.defaultDatas[indexPath.section][indexPath.row].imgName)
            cell.titleLabel.text = FirstItem.defaultDatas[indexPath.section][indexPath.row].fLabelname
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == carouselView {
            return 0
        }
        return (UIScreen.main.bounds.width - 80.0 * 4) / 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == carouselView {
            //MARK: 必须用 realCurrentIndexPath才是准确的
            let data = topAdsData[self.carouselView.realCurrentIndexPath.row]
            let web = BaseWebViewController()
            web.url = data.fLink
            topVC.navigationController?.pushViewController(web, animated: true)
        } else {
            let data = FirstItem.defaultDatas[indexPath.section][indexPath.row]
            
            if data.fLabelname == "全部分类" {
                topVC.tabBarController?.selectedIndex = 1
            } else {
                var vc: UIViewController!
                if data.fLabelname == "秒杀" {
                    vc = SecKillVC()
                } else {
                    vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsListVC.self)
                    let listVC = vc as! GoodsListVC
                    let t = FirstItem.defaultDatas[indexPath.section][indexPath.row].fLabelname
                    if t == "促销" {
                        listVC.type = .promotions
                    } else if t == "团购" {
                        listVC.type = .group
                    } else {
                        listVC.tags = data.fLabelname
                    }
                    vc.title = data.fLabelname
                }
                
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}
