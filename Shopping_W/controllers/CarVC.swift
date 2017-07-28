//
//  CarVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class CarVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableVIew: RefreshTableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var allPriceLabel: UILabel!
    @IBOutlet weak var selectAllBtn: UIButton!
    
    static var needsReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        submitBtn.layer.masksToBounds = true
        
        tableVIew.addHeaderAction {
            self.requestData()
        }
        tableVIew.beginHeaderRefresh()
    }
    
    func requestData() {
        CarModel.getList().setSuccessAction { (bm) in
            self.tableVIew.endHeaderRefresh()
            bm.whenSuccess {
                let arr = bm.list!.map({ (model) -> CarModel in
                    model.build(cellClass: CarTableViewCell.self)
                        .build(isFromStoryBord: true)
                        .build(heightForRow: 137)
                    model.setupCellAction { [unowned self] (idx) in
                        let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    return model
                })
                
                for item in arr {
                    item.selectedAction = { [unowned self] _ in
                        for model in arr {
                            if !model.isSelected {
                                self.selectAllBtn.isSelected = false
                                return
                            }
                        }
                        self.selectAllBtn.isSelected = arr.count > 0
                    }
                }
                
                
                self.tableVIew.dataArray = [arr]
                self.tableVIew.reloadData()
            }
        }.seterrorAction { (err) in
            self.tableVIew.endHeaderRefresh()
        }
    }

    func setupTableView() {
        tableVIew.delegate = self
        
        let nib = UINib(nibName: "CarSectionHeader", bundle: Bundle.main)
        tableVIew.register(nib, forHeaderFooterViewReuseIdentifier: "CarSectionHeader")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CarVC.needsReload {
            self.requestData()
        }
    }
    
    @IBAction func ac_selectAll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.tableVIew.dataArray.count < 1 {
            return
        }
        for item in self.tableVIew.dataArray[0] {
            let model = item as! CarModel
            model.isSelected = sender.isSelected
        }
        self.tableVIew.reloadData()
    }
    
    @IBAction func ac_submit(_ sender: UIButton) {
        let selectedArr = self.tableVIew.dataArray[0]
            .filter({ (item) -> Bool in
                return (item as! CarModel).isSelected
            })
        if selectedArr.isEmpty {
            return
        }

        let vc = OrderDetailVC()
        vc.showPayBtn = true
        vc.carModels = (selectedArr as! [CarModel])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: 代理
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CarSectionHeader") as! CarSectionHeader
//        return header
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15//48
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let a = UITableViewRowAction(style: .default, title: "删除") { (action, idx) in
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            if let model = self.tableVIew.dataArray[indexPath.section][indexPath.row] as? CarModel {
                model.delete(complete: { [unowned self] _ in
                    MBProgressHUD.hideHUD(forView: self.view)
                    self.tableVIew.dataArray[indexPath.section].remove(at: indexPath.row)
                    if self.tableVIew.dataArray[indexPath.section].isEmpty {
                        self.tableVIew.dataArray.remove(at: indexPath.section)
                        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
                    } else {
                        self.tableVIew.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                    }
                })
            }
        }
        return [a]
    }

    
}
