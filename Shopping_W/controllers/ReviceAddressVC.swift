//
//  ReviceAddressVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/27.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import RealmSwift
import MBProgressHUD

class ReviceAddressVC: BaseViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: CustomTableView!
    let addVC = Tools.getClassFromStorybord(sbName: .mine, clazz: AddressUpdateVC.self) as! AddressUpdateVC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBtn = UIButton(type: .system)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 52, height: 30)
        rightBtn.setTitle("新增", for: .normal)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.backgroundColor = CustomValue.common_red
        let item = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = item
        rightBtn.addTarget(self, action: #selector(ReviceAddressVC.ac_add), for: .touchUpInside)
        rightBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        
        tableView.estimatedRowHeight = 157
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        
        self.addChildViewController(addVC)
        addVC.topVC = self
        requestData()
    }
    
    func requestData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.requestListModel(params: ["method":"apiaddresslist"]).setSuccessAction { (bm: BaseModel<AddressModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            if bm.isSuccess {
                let arr = bm.list!.map({ (model) -> AddressModel in
                    model.build(cellClass: AddressTableViewCell.self).build(isFromStoryBord: true)
                    model.updateAcrion = { [unowned self] _ in
                        self.addVC.model = model
                        self.view.addSubview(self.addVC.view)
                    }
                    return model
                })
                self.tableView.dataArray = [arr]
                self.tableView.reloadData()
                
                if arr.count < 1 {
                    self.ac_add()
                }
            }
        }.seterrorAction { (err) in
            MBProgressHUD.hideHUD(forView: self.view)
        }
    }
    
    func ac_add() {
        addVC.model = nil
        view.addSubview(addVC.view)
    }
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ac = UITableViewRowAction(style: .default, title: "删除") { (action, idx) in
            let model = self.tableView.dataArray[indexPath.section][indexPath.row] as! AddressModel
            MBProgressHUD.show(text: "删除中", view: self.view, autoHide: false)
            NetworkManager.requestModel(params: ["method":"apiaddressdel", "fAddressid":model.fAddressid], success: { (bm: BaseModel<CodeModel>) in
                MBProgressHUD.hideHUD(forView: self.view)
                bm.whenSuccess {
                    self.tableView.dataArray[idx.section].remove(at: idx.row)
                    self.tableView.deleteRows(at: [idx], with: .left)
                }
            }, failture: { (err) in
                MBProgressHUD.hideHUD(forView: self.view)
            })
            
        }
        
        return [ac]
    }
    

}
