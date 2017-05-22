//
//  CustomTabBarVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/16.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CustomTabBarVC: BaseTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomTabBar.CustomTabBarItem.selectedTitleColor = UIColor.red
        CustomTabBar.CustomTabBarItem.normalTitleColor = UIColor.black
    }

}
