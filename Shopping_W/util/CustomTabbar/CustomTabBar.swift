//
//  CustomTabBar.swift
//  coreTextTest
//
//  Created by wanwu on 16/7/20.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

protocol CustomTabBarDelegate: UITabBarDelegate {
    func tabBar(_ tabBar: CustomTabBar, form: Int, to: Int)
}

class CustomTabBar: UITabBar {
    var itemList = [CustomTabBarItem]()
    fileprivate let margin = 6
    private var isBgAdded = false
    private var backgroundView: UIView!
    private var bgViewColor: UIColor?
    override var backgroundColor: UIColor? {
        didSet {
            bgViewColor = backgroundColor
            if backgroundView != nil {
                backgroundView.backgroundColor = bgViewColor
            }
        }
    }
    
    
    var selectedIndex: Int = 0 {
        didSet {
            if itemList.count > 0 {
                itemList[oldValue].isSelected = false
                itemList[selectedIndex].isSelected = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.backgroundColor = bgViewColor
        guard itemList.count > 0 else {
            return
        }
        
        let w = self.frame.size.width / CGFloat(itemList.count)
        for (i, item) in itemList.enumerated() {
            item.frame.size.width = w
            item.frame.origin.x = w * CGFloat(i)
        }
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        if items != nil {
            for item in items! {
                self.addTabBarItem(item)
            }
        }
    }
    
    func addTabBarItem(_ barItem: UITabBarItem) {
        if (!isBgAdded) {
            isBgAdded = true
            backgroundView = UIView(frame: self.bounds)
            backgroundView.backgroundColor = UIColor.clear
            self.addSubview(backgroundView)
        }
        
        let height = self.frame.height - CGFloat(margin) * 2
        let barFrame = CGRect(x: 0, y: CGFloat(margin), width: height, height: height)
        let cbar = CustomTabBarItem(frame: barFrame)
        cbar.tabBarItem = barItem
        
        cbar.addTarget(self, action: #selector(CustomTabBar.ac_click(_:)), for: .touchDown)
        
        itemList.append(cbar)
        self.addSubview(cbar)
    }
    
    func ac_click(_ sender: CustomTabBarItem) {
        let to = itemList.index(of: sender)!
        
        let os = selectedIndex
        
        selectedIndex = to
        
        if let de = delegate as? CustomTabBarDelegate {
            de.tabBar(self, form: os, to: to)
        }
        
    }
    
    
    
    
    
    
   ///内部类
    class CustomTabBarItem: UIButton {
        var badgeView = UILabel(frame: CGRect.zero)
        ///供用户自定义
        let customView = UIView()
        
        var badgeHeight: CGFloat = 16 {
            didSet {
                //不能直接赋值，所以，用了零时变量
                let ba = badgeValue
                self.badgeValue = ba
            }
        }
        fileprivate let observerArr = ["badgeValue", "title", "image", "selectedImage"]
        
        override var isHighlighted: Bool {
            set {
                
            }
            get {
                return false
            }
        }
        
        var tabBarItem: UITabBarItem? {
            willSet {
                if let newValue = newValue {
                    self.image = newValue.image
                    self.selectedImage = newValue.selectedImage
                    self.badgeValue = newValue.badgeValue
                    self.title = newValue.title
                    
                    //相同对象没必要再次监听
                    if newValue != tabBarItem {
                        itemAddObserver(newValue)
                    }
                }
            }
            
            didSet {
                if let old = oldValue {
                    if old != tabBarItem {
                        itemRemoveObserver(old)
                    }
                }
            }
        }
        
        deinit {
            if let item = tabBarItem {
                itemRemoveObserver(item)
            }
        }
        
        func itemAddObserver(_ item: UITabBarItem) {
            for path in observerArr {
                item.addObserver(self, forKeyPath: path, options: .new, context: nil)
            }
        }
        
        func itemRemoveObserver(_ item: UITabBarItem) {
            for path in observerArr {
                item.removeObserver(self, forKeyPath: path)
            }
        }
        
        func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [String : Any]?, context: UnsafeMutableRawPointer?) {
            if let item = object as? UITabBarItem {
                self.tabBarItem = item
            }
        }
        
        var image: UIImage? {
            willSet {
                self.setImage(newValue, for: UIControlState())
            }
        }
        var selectedImage: UIImage? {
            willSet {
                self.setImage(newValue, for: .selected)
            }
        }
        var title: String? {
            willSet {
                self.setTitle(newValue, for: UIControlState())
            }
        }
        
        static var imgHeightRatio: CGFloat = 0.7
        static var selectedTitleColor: UIColor = UIColor.red
        static var normalTitleColor: UIColor = UIColor.white
        static var defauleFontSize = 13
        
        override var frame: CGRect {
            willSet {
                let h = CustomTabBarItem.imgHeightRatio * newValue.height
                badgeView.frame.origin.x = newValue.width / 2 + h / 4
            }
        }
        
        var badgeValue: String? {
            willSet {
                if newValue != nil {
                    badgeView.frame.size.height = badgeHeight
                    badgeView.layer.cornerRadius = badgeView.frame.height / 2
                    badgeView.text = newValue
                    
                    let str = newValue! as NSString
                    
                    let size = CGSize(width: 100, height: badgeHeight)
                    //计算文字长度
                    let rec = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil)
                    badgeView.frame.size.width = badgeHeight + CGFloat(str.length < 2 ? 0 : rec.width - 10)
                    
                } else {
                    badgeView.text = nil
                    badgeView.frame = CGRect.zero
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        func setupUI() {
            badgeView.backgroundColor = UIColor.red
            badgeView.textColor = UIColor.white
            badgeView.layer.masksToBounds = true
            self.adjustsImageWhenHighlighted = false
            badgeView.font = UIFont.systemFont(ofSize: 12)
            badgeView.frame.origin.y = -3
            badgeView.textAlignment = .center
            self.addSubview(badgeView)
            
            self.addSubview(customView)
            
            self.setTitleColor(CustomTabBarItem.selectedTitleColor, for: .selected)
            self.setTitleColor(CustomTabBarItem.normalTitleColor, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(CustomTabBarItem.defauleFontSize))
            self.titleLabel?.textAlignment = NSTextAlignment.center
        }
        
        override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
            let h = (1 - CustomTabBarItem.imgHeightRatio) * self.frame.height
            let y = CustomTabBarItem.imgHeightRatio * self.frame.height
            let margin = CGFloat(y == 0 ? 0 : 4)
            return CGRect(x: 0, y: y + margin, width: self.frame.width, height: h)
        }
        
        override func  imageRect(forContentRect contentRect: CGRect) -> CGRect {
            let h = CustomTabBarItem.imgHeightRatio * self.frame.height
            return CGRect(x: (self.frame.width - h) / 2.0 , y: 0, width: h, height: h)
        }
        
        
    
    }

}
