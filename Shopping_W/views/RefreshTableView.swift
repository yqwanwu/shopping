//
//  RefreshTableView.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/18.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

/**
 * 自带刷新控件，方便一次性修改
 */
class RefreshTableView: CustomTableView {
    var pullTORefreshControl: PullToRefreshControl!
    
    var autoLoadWhenIsBottom = true {
        didSet {
            pullTORefreshControl.footer?.autoLoadWhenIsBottom = autoLoadWhenIsBottom
        }
    }

    override func setup() {
        super.setup()
        
        pullTORefreshControl = PullToRefreshControl(scrollView: self)
    }
    
    func addHeaderAction(action: @escaping () -> Void) {
        pullTORefreshControl.addDefaultHeader()
        pullTORefreshControl.header?.addAction(with: .refreshing, action: action)
    }
    
    func addFooterAction(action: @escaping () -> Void) {
        pullTORefreshControl.addDefaultFooter()
        pullTORefreshControl.footer?.addAction(with: .refreshing, action: action)
        pullTORefreshControl.footer?.autoLoadWhenIsBottom = autoLoadWhenIsBottom
    }
    
    func endHeaderRefresh() {
        pullTORefreshControl.header?.endRefresh()
    }
    
    func endFooterRefresh() {
        pullTORefreshControl.footer?.endRefresh()
    }
    
    func beginHeaderRefresh() {
        pullTORefreshControl.header?.beginRefresh()
    }
    
    func noMoreData() {
        self.pullTORefreshControl.footer?.state = .noMoreData
    }

}
