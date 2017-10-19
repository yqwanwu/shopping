//
//  CategoryVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/18.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import SnapKit

class CategoryVC: BaseViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: CustomTableView!
    @IBOutlet weak var collectionView: UICollectionView!
    let cellWidth: CGFloat = 80
    
    var goodsList = [CategoryModel]()
    var allList = [CategoryModel]()
    
    var currentPage = 1

    lazy var refreshContrl: PullToRefreshControl = {
        let p = PullToRefreshControl(scrollView: self.collectionView)
        p.addDefaultHeader().addDefaultFooter()
        
        return p
    } ()
    
    var selectedModel = CategoryModel()
    static let bkColor = UIColor.hexStringToColor(hexString: "f9f9f9")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CategoryVC.bkColor
        
        if Tools.getSystemVersion() > 10 {
            titleBack.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
        }
        
        titleBack.bounds.size.width = self.view.frame.width - 40
        searchBtn.layer.cornerRadius = 6

        collectionView.register(CollectionTitleHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        requestCategoryData()
        
//        refreshContrl.header?.addAction(with: .refreshing, action: {
//            self.currentPage = 1
//            self.requestGoodsData()
//        })
//        refreshContrl.footer?.addAction(with: .refreshing, action: {
//            self.currentPage += 1
//            
//        })
    }
    
    
    ///请求左边的数据
    func requestCategoryData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestListModel(params: ["method":"apicategorylist", "fPid":"0"], success: { (bm: BaseModel<CategoryModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                self.allList = bm.list!
                let arr = bm.list!.filter({ $0.fPid == 0 }).map({ (model) -> CategoryModel in
                    return model.build(isFromStoryBord: true).build(cellClass: CategoryLeftTableViewCell.self).build(heightForRow: 45)
                })
                self.tableView.dataArray = [arr]
                self.selectedModel = arr[0]
                self.selectedModel.isSelected = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if arr.count > 0 {
                        self.getGoods()
                    }
                }
            }
        }) { (err) in
            MBProgressHUD.hideHUD(forView: self.view)
        }
    }
    
    func getGoods() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let id = self.selectedModel.fCategoryid
        self.goodsList = self.allList.filter({ $0.fPid == id })
        for item in self.goodsList {
            item.list = self.allList.filter({ $0.fPid == item.fCategoryid })
        }
        self.collectionView.reloadData()
        MBProgressHUD.hideHUD(forView: self.view)
    }


    //MARK: 重写
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Tools.getSystemVersion() > 10 {
            titleBack.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var l = (self.collectionView.frame.width - cellWidth * 3) / 4 - 1
        if l < 0 {
            l = (self.collectionView.frame.width - cellWidth * 2) / 3 - 1
        }
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: l, bottom: 10, right: l)
    }

    
    //MARK: 代理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.tableView.dataArray[indexPath.section][indexPath.row] as! CategoryModel
        if data == selectedModel {
            return
        }
        data.isSelected = true
        selectedModel.isSelected = false
        tableView.reloadData()
        
        goodsList.removeAll()
        self.selectedModel = data
        self.getGoods()
//        self.collectionView.reloadData()
//        self.requestGoodsData()
        self.currentPage = 1
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? CategoryLeftTableViewCell {
            cell.isSelected = false
        }
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsList[section].list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! CollectionTitleHeader
        
        header.label.text = self.goodsList[indexPath.section].fCategoryname
        header.imgView.isHidden = true
        if indexPath.section == 0 {
            header.imgView.sd_setImage(with: URL.encodeUrl(string: self.selectedModel.fPic))
            header.imgView.isHidden = false
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 120)
        }
        
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryGoodsCollectionViewCell.getNameString(), for: indexPath) as! CategoryGoodsCollectionViewCell
        let goods = goodsList[indexPath.section].list[indexPath.row]
        cell.imgView.sd_setImage(with: URL.encodeUrl(string: goods.fPic), placeholderImage: #imageLiteral(resourceName: "placehoder"))
        cell.titleLabel.text = goods.fCategoryname
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.collectionView.frame.width - cellWidth * 3) / 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goods = goodsList[indexPath.section].list[indexPath.row]
        let id = goods.fCategoryid
        
        MBProgressHUD.show()
        let list = self.allList.filter({ $0.fPid == id })
        MBProgressHUD.hideHUD()
        
//        if list.isEmpty {
//            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
//            vc.goodsId = goods.fCategoryid
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsListVC.self) as! GoodsListVC
//            vc.type = .level2
//            vc.categoryId = goods.fCategoryid
//        self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsListVC.self) 
        vc.type = .level2
        vc.categoryId = goods.fCategoryid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private class CollectionTitleHeader: UICollectionReusableView {
        var imgView = UIImageView()
        
        var label = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(label)
            self.addSubview(imgView)
            imgView.contentMode = .scaleAspectFill
            imgView.layer.masksToBounds = true
            label.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(self)
                make.height.equalTo(40)
            }
            imgView.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(self)
                make.bottom.equalTo(label.snp.top)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
