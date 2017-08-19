//
//  QuestionVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/8/19.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class QuestionVC: BaseViewController {

    var tableView: CustomTableView!
    var models: [PwdQuestion]!
    var selectedAction: ((_ model: PwdQuestion) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = CustomTableView(frame: self.view.frame, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
        let arr = models.map { (m) -> CustomTableViewCellItem in
            let c = CustomTableViewCellItem().build(text: m.fQuestioncontent).build(cellClass: NormalTableViewCell.self).build(heightForRow: 50)
            c.setupCellAction({ (idx) in
                self.selectedAction?(m)
                self.dismiss(animated: true, completion: nil)
            })
            return c
        }
        tableView.dataArray = [arr]
    }

  
}
