//
//  CustomTabBarVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/16.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CustomTabBarVC: BaseTabBarController {
    
    static var instance: CustomTabBarVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomTabBarVC.instance = self
        CustomTabBarItem.selectedTitleColor = UIColor.red
        CustomTabBarItem.normalTitleColor = UIColor.black
    }
    
    func selectToFirst(index: Int) {
        if let nav = self.viewControllers?[index] as? UINavigationController {
            nav.popToRootViewController(animated: false)
            self.selectedIndex = index
            if let vc = nav.viewControllers.first {
                vc.tabBarController?.tabBar.isHidden = false
            }
        }
    }
    
    override func tabBar(_ tabBar: CustomTabBar, form: Int, to: Int) {
        super.tabBar(tabBar, form: form, to: to)
        
        if form == to {
            var vc = self.viewControllers?.first
            if let nav =  vc as? UINavigationController {
                vc = nav.viewControllers.first
            }
            if vc != nil {
                for v in vc!.view.subviews {
                    if let sv = v as? UIScrollView {
                        sv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }
            }
            
        }
    }
}
