//
//  ViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/16.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var carouselView: CarouselCollectionView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBack.bounds.size.width = self.view.frame.width - 40
        searchBtn.layer.cornerRadius = 6
        
        let top: CGFloat = CGFloat(200 - 70 * 2) / 3
        let left = (self.view.frame.width - 80.0 * 4) / 5
        itemCollectionView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
    }

    @IBAction func ac_address(_ sender: Any) {
        
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
            
        }
        
    }
}

