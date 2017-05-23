//
//  BaseViewController.swift
//  coreTextTest
//
//  Created by wanwu on 16/7/15.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    var showBottomBar = false
    ///更改为 true 默认显示
    var showCustomBackbtn = true
    var showOriginalColor = true
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait/*, .landscapeLeft, .landscapeRight*/]
    }
    
    override var shouldAutorotate: Bool {
        return BaseNavigationController.canRoateScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///设置导航栏背景色
//        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "返回icon.png"), for: .default)
//        self.navigationController?.navigationBar.shadowImage = #imageLiteral(resourceName: "blank.png")
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        
        view.backgroundColor = UIColor.hexStringToColor(hexString: "f0f0f0")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        BaseNavigationController.canRoateScreen = false
        
        //设置返回键的文字
        //        let bar = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.hidesBackButton = showCustomBackbtn
        if let nav = navigationController, showCustomBackbtn {
            if nav.viewControllers.count > 1 && navigationItem.leftBarButtonItem == nil {
                let bar = UIBarButtonItem(image: UIImage(named: "返回icon"), style: .plain, target: self, action: #selector(BaseViewController.ac_back))
//                bar.title = "返回"
                
                self.navigationItem.leftBarButtonItem = bar
            }
        }
        
        //防止系统的返回手势被屏蔽
        if self.navigationController != nil && self.navigationController?.viewControllers.count ?? 0 > 1 && (self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)))! {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    //滑动事件 代理
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.viewControllers.count ?? 0 > 1)
    }
    
    
    func ac_back() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.resignFirstResponder()
        
        if showCustomBackbtn && self.navigationController != nil {
            self.navigationItem.backBarButtonItem?.title = ""
            //            for v in (self.navigationController?.navigationBar.subviews)! {
            //                //MARK: 去掉蓝色的省略号。。。我不知道哪来的
            //                if NSStringFromClass(type(of: v)).contains("UINavigationItemButtonView") {
            //                    v.isHidden = true
            //                }
            //            }
        }
        
        if let nav = self.navigationController, let tab = self.tabBarController?.tabBar {
            if nav.viewControllers.count > 1 {
                tab.isHidden = !showBottomBar
            } else {
                tab.isHidden = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = self.navigationController, let tab = self.tabBarController?.tabBar {
            if nav.viewControllers.count > 1 {
                tab.isHidden = !showBottomBar
            } else {
                tab.isHidden = false
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if showOriginalColor {
            var itemArr = [UIBarButtonItem]()
            if let rights = self.navigationItem.rightBarButtonItems {
                itemArr.append(contentsOf: rights)
            }
            
            if let lefts = self.navigationItem.leftBarButtonItems {
                itemArr.append(contentsOf: lefts)
            }
            
            for item in itemArr {
                if let img = item.image {
                    item.image? = img.withRenderingMode(.alwaysOriginal)
                }
            }
        }
        
        //自动隐藏 tabBar
        if let nav = self.navigationController, let tab = self.tabBarController?.tabBar {
            if nav.viewControllers.count > 1 {
                tab.isHidden = !showBottomBar
            } else {
                tab.isHidden = false
            }
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.alpha = 1
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //        var tab = self.tabBarController
        //        if tab == nil {
        //            tab = self.navigationController?.tabBarController
        //        }
        //        tab?.customTabBar.selectedIndex = tab?.selectedIndex ?? 0
        
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        set {
            
        }
        get {
            return false
        }
    }
}

extension BaseViewController {

}
