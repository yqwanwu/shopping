//
//  SexPopoverVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class SexPopoverVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }

    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            debugPrint("男")
        case 1:
            debugPrint("女")
        case 2:
            debugPrint("保密")
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
