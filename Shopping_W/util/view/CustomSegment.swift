//
//  CustomSegment.swift
//  caizhu
//
//  Created by wanwu on 16/8/25.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class CustomSegment: UIView {
    private var items = [UIButton]()
    var selectedItem: UIButton?
    var selectedBackgroundColor: UIColor? {
        didSet {
            selectedItem?.backgroundColor = selectedBackgroundColor
        }
    }
    var normalBackgroundColor: UIColor? {
        didSet {
            for item in items {
                item.backgroundColor = normalBackgroundColor
            }

        }
    }
    
    var selectedIndex = 0 {
        didSet {
            if items.count > selectedIndex {
                selectAItem(sender: items[selectedIndex])
            }
        }
    }
    
    func addItem(item: UIButton) {
        items.append(item)
        item.addTarget(self, action: #selector(CustomSegment.ac_click(sender:)), for: .touchUpInside)
        self.addSubview(item)
        item.backgroundColor = normalBackgroundColor
        layoutSubviews()
    }
    
    func removeItem(at index: Int) {
        items[index].removeFromSuperview()
        items.remove(at: index)
        layoutSubviews()
    }
    
    @objc private func ac_click(sender: UIButton) {
        selectAItem(sender: sender)
        if let index = items.index(of: sender) {
            selectedIndex = index
        }
    }
    
    private func selectAItem(sender: UIButton) {
        selectedItem?.backgroundColor = normalBackgroundColor
        selectedItem?.isSelected = false
        selectedItem = sender
        sender.isSelected = true
        sender.backgroundColor = selectedBackgroundColor
    }
    
    override func layoutSubviews() {
        var x: CGFloat = 0
        for item in items {
            item.frame.origin.y = 0
            item.frame.origin.x = x
            x += item.frame.width
        }
        selectedItem?.backgroundColor = selectedBackgroundColor
    }
    
    
}
