//
//  BaseTabBarController.swift
//  coreTextTest
//
//  Created by wanwu on 16/7/19.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController, CustomTabBarDelegate {
    let customTabBar = CustomTabBar()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft, .landscapeRight]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBar.layoutSubviews()
    }
    
    override var shouldAutorotate: Bool {
        return BaseNavigationController.canRoateScreen
    }
    
    override var selectedIndex: Int {
        willSet {
            customTabBar.selectedIndex = newValue
            super.selectedIndex = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabBar.frame = self.tabBar.bounds
        self.tabBar.addSubview(customTabBar)
        customTabBar.delegate = self
        self.selectedIndex = 0
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        BaseNavigationController.canRoateScreen = false
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        if viewControllers != nil {
            for vc in viewControllers! {
                customTabBar.addTabBarItem(vc.tabBarItem)
            }
        }
    }
    
    func tabBar(_ tabBar: CustomTabBar, form: Int, to: Int) {
        self.selectedIndex = to
        customTabBar.selectedIndex = to
    }
    
    func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [String : Any]?, context: UnsafeMutableRawPointer?) {
        for (_, it) in self.tabBar.items!.enumerated() {
            if it.isEqual(object) {
                
//                print(self.tabBar.subviews[index].subviews)
                break
            }
        }
    }

    var inited = false
    override func viewWillAppear(_ animated: Bool) {
        if (!inited) {
            for v in self.tabBar.subviews {
                if v.isKind(of: UIControl.self) {
                    v.isHidden = true
                }
            }
            
            if viewControllers != nil && customTabBar.subviews.count < 1 {
                for vc in viewControllers! {
                    customTabBar.addTabBarItem(vc.tabBarItem)
                }
            }
            inited = true
            self.selectedIndex = 0
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
