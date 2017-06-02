//
//  ViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/16.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var carouselView: CarouselCollectionView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var adImgView: UIImageView!
    
    @IBOutlet weak var tableView: RefreshTableView!
    
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
        
        
    }
    
    @IBAction func ac_address(_ sender: Any) {
        
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
    
    
    //MARK: 代理    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselView {
            return 3
        }
        return FirstItem.defaultDatas.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == carouselView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCollectionViewCell
            cell.imageView.image = #imageLiteral(resourceName: "placehoder")
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
                    if FirstItem.defaultDatas[indexPath.row].title == "促销" {
                        listVC.type = .promotions
                    }
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
}

