//
//  CarVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class CarVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableVIew: RefreshTableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var allPriceLabel: UILabel!
    @IBOutlet weak var selectAllBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        submitBtn.layer.masksToBounds = true
    }

    func setupTableView() {
        let c = CustomTableViewCellItem()
            .build(cellClass: CarTableViewCell.self)
            .build(isFromStoryBord: true)
            .build(heightForRow: 137)
        
        c.setupCellAction { [unowned self] (idx) in
            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableVIew.delegate = self
        
        tableVIew.dataArray = [[c, c, c], [c, c]]
        
        let nib = UINib(nibName: "CarSectionHeader", bundle: Bundle.main)
        tableVIew.register(nib, forHeaderFooterViewReuseIdentifier: "CarSectionHeader")
    }
    
    
    
    @IBAction func ac_selectAll(_ sender: UIButton) {
    }
    
    @IBAction func ac_submit(_ sender: UIButton) {
        let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: OrderVC.self) as! OrderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ac_test(_ sender: Any) {
        ///测试商品详情
        GoodsDetailModel.requestData(fGoodsid: 1, fGeid: nil).setSuccessAction { (bm) in
            bm.whenSuccess {
                
            }
        }
    }
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CarSectionHeader") as! CarSectionHeader
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let a = UITableViewRowAction(style: .default, title: "删除") { (action, idx) in
            self.tableVIew.dataArray[indexPath.section].remove(at: indexPath.row)
            if self.tableVIew.dataArray[indexPath.section].isEmpty {
                self.tableVIew.dataArray.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
            } else {
                self.tableVIew.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            }
        }
        return [a]
    }

    
}
