//
//  CategoryVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/18.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class CategoryVC: BaseViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: CustomTableView!
    @IBOutlet weak var collectionView: UICollectionView!
    let cellWidth: CGFloat = 80
    
    var goodsList = [GoodsModel]()
    
    var currentPage = 1
    var CurrentCategoryId = 0
    
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
        
        titleBack.bounds.size.width = self.view.frame.width - 40
        searchBtn.layer.cornerRadius = 6

        requestCategoryData()
        
        refreshContrl.header?.addAction(with: .refreshing, action: {
            self.currentPage = 1
            self.requestGoodsData()
        })
        refreshContrl.footer?.addAction(with: .refreshing, action: {
            self.currentPage += 1
            self.requestGoodsData()
        })
    }
    
    ///请求左边的数据
    func requestCategoryData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestListModel(params: ["method":"apicategorylist"], success: { (bm: BaseModel<CategoryModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            bm.whenSuccess {
                let arr = bm.list!.map({ (model) -> CategoryModel in
                    return model.build(isFromStoryBord: true).build(cellClass: CategoryLeftTableViewCell.self).build(heightForRow: 70)
                })
                self.tableView.dataArray = [arr]
                self.selectedModel = arr[0]
                self.selectedModel.isSelected = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if arr.count > 0 {
                        self.CurrentCategoryId = arr[0].fCategoryid
                        self.requestGoodsData()
                    }
                }
            }
        }) { (err) in
            MBProgressHUD.hideHUD(forView: self.view)
        }
    }

    ///请求商品信息
    func requestGoodsData() {
        if self.currentPage == 1 {
            goodsList.removeAll()
        }
        let params = ["method":"apigoodslist", "fCategoryid":CurrentCategoryId, "currentPage":currentPage, "pageSize":20] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params, success: { (bm: BaseModel<GoodsModel>) in
            self.refreshContrl.endRefresh()
            if !bm.pageInfo!.hasNextPage {
                self.refreshContrl.footer?.state = .noMoreData
            }
            bm.whenSuccess {
                self.goodsList.append(contentsOf: (bm.pageInfo?.list)!)
                self.collectionView.reloadData()
            }
        }) { (err) in
            self.refreshContrl.endRefresh()
        }
    }
    
    //MARK: 重写
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        selectedModel = data
        tableView.reloadData()
        
        goodsList.removeAll()
        self.CurrentCategoryId = data.fCategoryid
        self.collectionView.reloadData()
        self.requestGoodsData()
        self.currentPage = 1
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? CategoryLeftTableViewCell {
            cell.isSelected = false
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryGoodsCollectionViewCell.getNameString(), for: indexPath) as! CategoryGoodsCollectionViewCell
        let goods = goodsList[indexPath.row]
        cell.imgView.sd_setImage(with: URL.encodeUrl(string: goods.fUrl), placeholderImage: #imageLiteral(resourceName: "placehoder"))
        cell.titleLabel.text = goods.fGoodsname
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.collectionView.frame.width - cellWidth * 3) / 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsListVC.self) as! GoodsListVC
        vc.type = .level2
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
