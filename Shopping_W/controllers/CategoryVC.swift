//
//  CategoryVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/18.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CategoryVC: BaseViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: CustomTableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var currentTableCell: UITableViewCell?
    let cellWidth: CGFloat = 95
    
    static let bkColor = UIColor.hexStringToColor(hexString: "f9f9f9")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CategoryVC.bkColor
        
        titleBack.bounds.size.width = self.view.frame.width - 40
        searchBtn.layer.cornerRadius = 6
        
        let c = CustomTableViewCellItem().build(text: "空调").build(isFromStoryBord: true).build(cellClass: CategoryLeftTableViewCell.self).build(heightForRow: 70)
        tableView.dataArray = [[c, c, c, c]]
    
    }
    
    
    //MARK: 重写
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentTableCell == nil {
            currentTableCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
            currentTableCell?.isSelected = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let l = (self.collectionView.frame.width - cellWidth * 3) / 4
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: l, bottom: 10, right: l)
    }

    
    //MARK: 代理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! CategoryLeftTableViewCell
        currentTableCell?.isSelected = false
        cell.isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! CategoryLeftTableViewCell
        cell.isSelected = false
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryGoodsCollectionViewCell.getNameString(), for: indexPath) as! CategoryGoodsCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.collectionView.frame.width - cellWidth * 3) / 4
    }
    
}
