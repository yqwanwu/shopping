//
//  GoodsTypeView.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsTypeView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    let k_name = "name"
    let k_value = "value"
    let k_isShow = "isshow"
    
    var types = [GoodsTypeModel]() {
        didSet {
            if types.count > 0 {
                types[0].isSelected = true
                setupArr()
            }
        }
    }
    
    private var selectedModels = [GoodsExtTypeModel]()
    
    private var setArr = [[GoodsExtTypeModel]]()
    
    private func setupArr()  {
        var arr = [[GoodsExtTypeModel]]()
        let json = JSON(parseJSON: types[0].fExparams)
        for i in 0..<json.arrayValue.count {
            var set = Set<GoodsExtTypeModel>()
            for d in types {
                let typeJson = JSON(parseJSON: d.fExparams)
                let model = GoodsExtTypeModel(json: typeJson[i])
                model.model = d
                if model.isshow {//如果没有一个是可选，就没有必要加入
                    set.insert(model)
                }
            }
            var s = set.sorted { (s1, s2) -> Bool in
                return s1.value < s2.value
            }
            if s.count > 0 {
                let titleModle = GoodsExtTypeModel()
                titleModle.value = s[0].name
                titleModle.name = s[0].name
                s.insert(titleModle, at: 0)
                arr.append(s)
            }
            
        }
        setArr = arr
        
    }
    
    func getSize(idx: IndexPath) -> CGSize {
        let str = self.setArr[idx.section][idx.row].value
        let rec = (str as NSString).boundingRect(with: CGSize(width: 500, height: 35), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)], context: nil)
        let w = rec.width + 10
        return CGSize(width: w > 30 ? w : 30, height: 35)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let nib = UINib(nibName: GoodTypeCollectionViewCell.getNameString(), bundle: Bundle.main)
        self.register(nib, forCellWithReuseIdentifier: GoodTypeCollectionViewCell.getNameString())
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.register(BLankHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func itemIsShow(title: String, value: String, json: JSON) -> Bool {
        for j in json.arrayValue {
            if j[k_name].stringValue == title && j[k_value].stringValue == value && j[k_isShow].boolValue {
                return true
            }
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setArr[section].count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return setArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getSize(idx: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodTypeCollectionViewCell.getNameString(), for: indexPath) as! GoodTypeCollectionViewCell
        let arr = setArr[indexPath.section]
        let model = arr[indexPath.row]
        cell.btn.setTitle(model.value, for: .normal)
        if indexPath.row == 0 {
            model.state = .title
            cell.btn.setTitle(model.name + ":", for: .normal)
        } else {
//            let selectedArr = self.types.filter({$0.isSelected})
//            if selectedArr.count > 0 {
//                let selected = selectedArr[0]
//                if model.isshow {
//                    let json = JSON(parseJSON: selected.fExparams)
//                    if itemIsShow(title: model.name, value: model.value, json: json) {
//                        cell.state = .selected
//                    }
//                }
//            }
        }
        
        cell.model = model
        
//        cell.clickAction = { [unowned self] _ in
//            
//        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let arr = setArr[indexPath.section]
        let m = arr[indexPath.row]
        if m.state == .title || m.state == .disable {
            return
        }
        
        //一行只选一个
        for item in self.setArr[indexPath.section] {
            if item.isEqual(m) {
                if item.state == .selected {
                    item.state = .enable
                } else {
                    item.state = .selected
                }
            } else {
                item.state = .enable
            }
        }
        
        self.resetSate()
        
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
    }
    
    func resetSate() {
        let selectedArr = self.setArr.flatMap({ $0.filter({ $0.state == .selected }) })
        if selectedArr.count < 1 {
            return
        }
        
        var tmpSet = Set<GoodsExtTypeModel>()
        
        for model in self.types {
            let json = JSON(parseJSON: model.fExparams)
            var i = 0
            for type in json.arrayValue {
                let tmp = GoodsExtTypeModel(json: type)
                if selectedArr.contains(tmp) {
                    i += 1
                }
            }
            
            let arr = GoodsExtTypeModel.gteArr(jsonString: model.fExparams)
            if i >= selectedArr.count {//符合要求
                for items in self.setArr {
                    for item in items {
                        if arr.contains(item) {
                            tmpSet.insert(item)
                        }
                    }
                }
                model.isSelected = true
            } else {
                model.isSelected = false
            }
        }
        
        for items in self.setArr {
            for item in items {
                if tmpSet.contains(item) {
                    if item.state != .selected {
                        item.state = .enable
                    }
                } else {
                    if selectedArr.count < setArr.count {
                        for sa in selectedArr {
                            if items.contains(sa) {
                                item.state = .enable
                            } else {
                                item.state = .disable
                            }
                        }
                    } else {
                        item.state = .disable
                    }
                }
            }
        }
    }
    
    private class BLankHeaderView: UICollectionReusableView {
        
    }
}



