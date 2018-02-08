//
//  BankCardListVC.swift
//  Shopping_W
//
//  Created by wanwu on 2018/2/6.
//  Copyright © 2018年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class BankCardListVC: BaseViewController {

    @IBOutlet weak var tableView: CustomTableView!
    var selectedAction: ((BankCardModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "银行卡"
        tableView.delegate = self
        requestData()
    }
    
    func requestData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestListModel(params: ["method":"apifinacnes"]).setSuccessAction { (bm:BaseModel<BankCardModel>) in
            bm.whenSuccess {
                MBProgressHUD.hideHUD(forView: self.view)
                let arr = bm.list!.map({ (model) -> BankCardModel in
                    model.build(cellClass: CardListCell.self)
                    .build(heightForRow: 75)
                    model.cellAction = { [unowned self] _ in
                        self.selectedAction?(model)
                    }
                    return model
                })
                self.tableView.dataArray = [arr]
                self.tableView.reloadData()
            }
            }.seterrorAction { (err) in
                MBProgressHUD.hideHUD(forView: self.view)
        }
    }
    
    deinit {
        print("asdasdasdasds")
    }
}


extension BankCardListVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let a = UITableViewRowAction(style: .default, title: "删除") { [weak self] (action, idx) in
            let model = self?.tableView.dataArray[0][idx.row] as! BankCardModel
            let params = ["method":"apidelfinance", "fFinanceid":model.fFinanceid] as [String : Any]
            NetworkManager.requestTModel(params: params).setSuccessAction(action: { (bm: BaseModel<CodeModel>) in
                bm.whenSuccess {
                    self?.tableView.dataArray[0].remove(at: indexPath.row)
                    self?.tableView.reloadData()
                }
            })
        }
        
        return [a]
    }
}


class CardListCell: CustomTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? BankCardModel {
                self.titleLabel.text = m.fBankname
                self.numberLabel.text = m.fMaskaccount
            }
        }
    }
}

