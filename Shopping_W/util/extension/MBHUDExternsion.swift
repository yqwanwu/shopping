//
//  MBHUDExternsion.swift
//  caizhu
//
//  Created by wanwu on 16/9/8.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

extension MBProgressHUD {
    @discardableResult
    class func show(text: String? = nil, icon: UIImage? = nil, view: UIView? = nil, dimBackground: Bool = true, autoHide: Bool = false) -> MBProgressHUD {
        var bkView = view
        var hud: MBProgressHUD!
        
        if view == nil {
            bkView = UIApplication.shared.keyWindow
        }
        if bkView == nil {
            return MBProgressHUD()
        }
        hud = MBProgressHUD.showAdded(to: bkView!, animated: true)
        hud.label.font = UIFont.systemFont(ofSize: 12)
        
        if dimBackground {
            hud?.backgroundColor = UIColor.clear
        }
        
        if let t = text {
            hud?.label.text = t
        }
        
        hud?.removeFromSuperViewOnHide = true
//
        if autoHide {
            hud?.hide(animated: true, afterDelay: 2.5)
        }
        
        return hud
    }
    
    class func show(errorText: String?, toView: UIView? = nil, dimBackground: Bool = true, autoHide: Bool = true) {
        let img = UIImage(named: "MBProgressHUD.bundle/error.png")
        let hud = show(text: errorText, icon: img, view: toView, dimBackground: dimBackground, autoHide: autoHide)
        hud.mode = .customView
        dim(hud: hud)
    }
    
    class func show(successText: String?, toView: UIView? = nil, dimBackground: Bool = true, autoHide: Bool = true) {
        let img = UIImage(named: "MBProgressHUD.bundle/success.png")
        let hud = show(text: successText, icon: img, view: toView, dimBackground: dimBackground, autoHide: autoHide)
        hud.mode = .customView
        dim(hud: hud)
    }
    
    class func show(warningText: String?, toView: UIView? = nil, dimBackground: Bool = true, autoHide: Bool = true) {
        let img = UIImage(named: "MBProgressHUD.bundle/hudWarning.png")
        let hud = show(text: warningText, icon: img, view: toView, dimBackground: dimBackground, autoHide: autoHide)
        hud.mode = .customView
        dim(hud: hud)
    }
    
    class func dim(hud: MBProgressHUD) {
//        let y = UIScreen.main.bounds.height / 2 - 100
//        hud.yOffset = Float(y)
        hud.animationType = .zoom
        hud.isUserInteractionEnabled = false
    }
    
    
    class func hideHUD(forView view: UIView? = nil) {
        hide(for: view ?? UIApplication.shared.keyWindow!, animated: true)
    }
    
    class func showTip(text: String) {
        let rec = (text as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 100, height: 200), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)], context: nil)
        
        let margin: CGFloat = 10
        
        let label = UILabel(frame: rec)
        label.text = text
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.frame.origin.y = margin
        label.frame.origin.x = margin
        
        let bk = UIView(frame: rec)
        bk.bounds.size.width += margin * 2
        bk.bounds.size.height += margin * 2
        bk.layer.cornerRadius = 6
        bk.center.y = UIScreen.main.bounds.height + 10
        bk.center.x = UIScreen.main.bounds.width / 2
        bk.backgroundColor = UIColor.black
        bk.alpha = 0.8
        bk.addSubview(label)
        UIApplication.shared.keyWindow?.addSubview(bk)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            bk.center.y = UIScreen.main.bounds.height - 150
            }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.3, animations: {
                bk.alpha = 0
                }, completion: { (c) in
                    bk.removeFromSuperview()
            })
        }
    }
    
    
}
