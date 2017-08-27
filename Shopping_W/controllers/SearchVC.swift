//
//  SearchVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/19.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class SearchVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    var tableView = RefreshTableView()
    var currentPage = 1
    
    var layout = LeftAlignLayout()
    var datas = ["dasdadasdadasda", "as3rwe", "dasf", "etw", "qwrqwtwete", "qweqwrw"
        , "wqrweg", "@!$324", "2423432", "454tr"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        searchBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        searchBtn.layer.masksToBounds = true

        searchBar.delegate = self
        
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        collectionView.setCollectionViewLayout(layout, animated: true)
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        self.view.addSubview(tableView)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        self.tableView.addFooterAction { [unowned self] _ in
            self.currentPage += 1
            self.requstData()
        }
        
        requestHot()
    }
    
    func requestHot() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.JsonPostRequest(params: ["method":"apihotsearchtags"], success: { (j) in
            MBProgressHUD.hideHUD(forView: self.view)
            if j["code"].stringValue == "0" {
                self.datas = j["list"].arrayValue.map({ (json) -> String in
                    return json["fSerchtext"].stringValue
                })
                self.layout.setWidthFotItem { [unowned self] (idx) -> CGSize in
                    let rec = (self.datas[idx.row] as NSString).boundingRect(with: CGSize(width: 500, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)], context: nil)
                    return CGSize(width: rec.width + 20, height: 30)
                }
                self.collectionView.reloadData()
            } else {
                MBProgressHUD.show(errorText: j["message"].stringValue)
            }
        }) { (err) in
            MBProgressHUD.hideHUD(forView: self.view)
        }
    }
    
    func requstData() {
        let params = ["method":"apigoodsSearch", "fSearchtext":self.searchBar.text ?? "", "currentPage":currentPage, "pageSize":CustomValue.pageSize] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params).setSuccessAction { (bm: BaseModel<GoodsModel>) in
            self.tableView.endFooterRefresh()
            bm.whenSuccess {
                var arr = bm.pageInfo!.list!.map({ (model) -> GoodsModel in
                    model.build(heightForRow: 118)
                    model.build(cellClass: GoodsCommonTableViewCell.self)
                    
                    model.setupCellAction { [unowned self] (idx) in
                        let vc = Tools.getClassFromStorybord(sbName: Tools.StoryboardName.shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
                        vc.goodsId = model.fGoodsid
                        vc.picUrl = model.fUrl
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    return model
                })
                
                if arr.isEmpty {
                    MBProgressHUD.show(warningText: "没有相关数据")
                } else {
                    self.tableView.isHidden = false
                }
                
                if !bm.pageInfo!.hasNextPage {
                    self.tableView.noMoreData()
                }
                
                if self.currentPage > 1 && self.tableView.dataArray.count > 0 {
                    arr.insert(contentsOf: self.tableView.dataArray[0] as! [GoodsModel], at: 0)
                }
                self.tableView.dataArray = [arr]
                
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func ac_search(_ sender: Any) {
        self.currentPage = 1
        self.searchBar.resignFirstResponder()
        self.requstData()
    }
    
    
    
    //MARK: 代理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        cell.titleLabel.text = datas[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = datas[indexPath.row]
        self.searchBar.text = text
        
        self.ac_search(searchBtn)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !Tools.stringIsNotBlank(text: searchText) {
            self.tableView.isHidden = true
        }
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.ac_search(searchBtn)
        }
        return true
    }
    
}
