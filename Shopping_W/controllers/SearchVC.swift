//
//  SearchVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/19.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    
    var layout = LeftAlignLayout()
    var datas = ["dasdadasdadasda", "as3rwe", "dasf", "etw", "qwrqwtwete", "qweqwrw"
        , "wqrweg", "@!$324", "2423432", "454tr"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        searchBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        searchBtn.layer.masksToBounds = true

        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        collectionView.setCollectionViewLayout(layout, animated: true)
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        layout.setWidthFotItem { [unowned self] (idx) -> CGSize in
            let rec = (self.datas[idx.row] as NSString).boundingRect(with: CGSize(width: 500, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)], context: nil)
            return CGSize(width: rec.width + 20, height: 30)
        }
    }

    @IBAction func ac_search(_ sender: Any) {
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

}
