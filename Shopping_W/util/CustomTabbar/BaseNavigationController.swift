//
//  BaseNavigationController.swift
//  coreTextTest
//
//  Created by wanwu on 16/7/19.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var currentShowVC: UIViewController?
    
    static var canRoateScreen = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft, .landscapeRight]
    }
    
    override var shouldAutorotate: Bool {
        return BaseNavigationController.canRoateScreen
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.hexStringToColor(hexString: "4b4b4b"), NSFontAttributeName:UIFont.systemFont(ofSize: 21)]
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        BaseNavigationController.canRoateScreen = false
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            self.currentShowVC = nil
        } else {
            self.currentShowVC = viewController
        }
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
 
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            return self.currentShowVC == self.topViewController
        }
        return true
    }
    
}


