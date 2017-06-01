//
//  TabView.swift
//  caizhu
//
//  Created by wanwu on 16/8/26.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class TabView: UIView {
    let scroll: UIScrollView = UIScrollView()
    var margin: CGFloat = 20
    var showSeparator = false
    var lineTopMargin: CGFloat = 0
    var actions: ((_ index: Int) -> Void)? = nil
    var selectedIndex = 0 {
        didSet {
            if selectedIndex >= items.count {
                return
            }
            let btn = items[selectedIndex]
            let oldBtn = items[oldValue]
            oldBtn.isSelected = false
            btn.isSelected = true
            
            UIView.animate(withDuration: 0.4) { 
                self.bottomView.center.x = btn.center.x
                self.bottomView.bounds.size.width = btn.bounds.width - 34
                
                let w = self.frame.width
                
                if btn.center.x > w / 2 && btn.center.x < self.scroll.contentSize.width - w / 2 {
                    self.scroll.contentOffset.x = btn.center.x - w / 2
                } else {
                    if btn.center.x < w / 2 {
                        self.scroll.contentOffset.x = 0
                    } else if self.scroll.contentSize.width > w {
                        self.scroll.contentOffset.x = self.scroll.contentSize.width - w
                    }
                    
                }
            }
        }
    }
    let bottomView = UIView()
    
    
    var items: [UIButton]! {
        didSet {
            if oldValue != nil {
                for btn in oldValue {
                    btn.removeFromSuperview()
                }
            }
            
            for btn in items {
                scroll.addSubview(btn)
            }
        }
    }

    override func layoutSubviews() {
        scroll.frame = bounds
        if items.count < 1 {
            return
        }
        bottomView.frame = CGRect(x: 0, y: frame.height - 2, width: 40, height: 2)
        let btn = items[selectedIndex]
        self.bottomView.center.x = btn.center.x
        self.bottomView.bounds.size.width = btn.bounds.width - 34
        
        var index: CGFloat = 0
        for btn in items {
            if let title = btn.title(for: .normal) {
                let rec = (title as NSString).boundingRect(with: CGSize(width: 500, height: frame.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil, context: nil)
                
                btn.frame = CGRect(x: 0, y: 0, width: rec.width, height: frame.height)
                
                btn.addTarget(self, action: #selector(TabView.ac_click(sender:)), for: .touchUpInside)
            } else {
                
            }
            btn.bounds.size.width += margin * 2
            btn.frame.origin.x = index
            index += btn.frame.width
            
//            scroll.addSubview(btn)
        }
        
        ///均匀分布
        if index < frame.width {
            var i: CGFloat = 0
            for item in items {
                item.frame.size.width += (frame.width - index) / CGFloat(items.count)
                item.frame.origin.x = i
                i += item.frame.width
            }
        }
        
        scroll.contentSize = CGSize(width: index, height: 0)
        
        for btn in items {
            if showSeparator && btn != items.last {
                let line = UIView(frame: CGRect(x: btn.frame.width - 1, y: lineTopMargin, width: 1, height: btn.frame.height - lineTopMargin * 2))
                line.backgroundColor = UIColor.hexStringToColor(hexString: "e5e5e5")
                btn.addSubview(line)
            }
        }
    }
    
    @objc private func ac_click(sender: UIButton) {
        if let index = items.index(of: sender) {
            if let ac = actions {
                ac(index)
            }
            selectedIndex = index
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        steup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steup()
    }
    
    func steup() {
        addSubview(scroll)
        scroll.frame = bounds
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        
        bottomView.backgroundColor = UIColor.hexStringToColor(hexString: "fdd000")
        scroll.addSubview(bottomView)
    }
    
}
