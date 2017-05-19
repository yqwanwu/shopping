//
//  ContentScrollView.swift
//  coreTextTest
//
//  Created by wanwu on 16/7/15.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class ContentScrollView: UIScrollView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        
        if (view?.superview?.isKind(of: UITableViewCell.self))! || NSStringFromClass((view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true;
    }

}
