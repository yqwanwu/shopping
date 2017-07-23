//
//  SexPopoverVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class SexPopoverVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }
    
    weak var topVC: PersonVC!

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let p = PersonMdel.readData() else {
            return
        }
        MBProgressHUD.show()
        var prefix = " "
        switch indexPath.row {
        case 0:
            p.fSex = 1
        case 1:
            p.fSex = 0
        case 2:
            p.fSex = 3
            prefix = ""
        default:
            break
        }
        
        p.update {
            MBProgressHUD.hideHUD()
            self.dismiss(animated: true, completion: nil)
            self.topVC.sexBtn.setTitle(prefix + p.sexString(), for: .normal)
        }
        
    }
    
}
