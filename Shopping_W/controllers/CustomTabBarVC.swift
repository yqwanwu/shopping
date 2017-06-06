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
}
