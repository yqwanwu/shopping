//
//  CarVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import Realm
import RealmSwift

class CarVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableVIew: RefreshTableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var allPriceLabel: UILabel!
    @IBOutlet weak var selectAllBtn: UIButton!
    
    static var needsReload = false
    var carList = [CarListModel]()
    
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
        if !PersonMdel.isLogined() {
            self.carList = CarModel.readTreeDataFromDB()
            self.updateView()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.tableVIew.endHeaderRefresh()
            })
            return
        }
        
        NetworkManager.requestListModel(params: ["method":"apimyshopcartlist"]).setSuccessAction { (bm: BaseModel<CarListModel>) in
            self.tableVIew.endHeaderRefresh()
            bm.whenSuccess {
                self.carList = bm.list!
                self.updateView()
            }
        }.seterrorAction { (err) in
            self.tableVIew.endHeaderRefresh()
        }
    }
    
    func updateView() {
        var arr = [[CarModel]]()
        for item in self.carList {
            arr.append(self.dealModels(models: item.goodList))
            for goods in item.goodList {
                goods.carList = item
            }
        }
        self.tableVIew.dataArray = arr
        self.tableVIew.reloadData()
        let notSelected = (arr.flatMap({ $0 })).filter({ !$0.isSelected })
        self.selectAllBtn.isSelected = arr.count > 0 && notSelected.count < 1
        self.updateAllPrice()
    }
    
    func dealModels(models: [CarModel]) -> [CarModel] {
        let arr = models.map({ (model) -> CarModel in
            model.build(cellClass: CarTableViewCell.self)
                .build(isFromStoryBord: true)
                .build(heightForRow: 120)
            model.countAction = { _ in
                self.updateAllPrice()
            }
            
            model.setupCellAction { [unowned self] (idx) in
                let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) 
                switch model.fType {
                case 0:
                    vc.type = .normal
                case 1:
                    vc.type = .group
                case 2:
                    vc.type = .seckill
                case 3, 4, 5, 6:
                    vc.type = .promotions
                default:
                    break
                }
                vc.promotionid = model.fPromotionid
                vc.goodsId = model.fGoodsid
                vc.picUrl = model.fGoodimg
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return model
        })
        
        for item in arr {
            item.selectedAction = { [unowned self] _ in
                if !self.updateByAllBtn {
                    for model in arr {
                        if !model.isSelected {
                            self.selectAllBtn.isSelected = false
                            return
                        }
                    }
                    let notSelected = arr.filter({ !$0.isSelected })
                    self.selectAllBtn.isSelected = arr.count > 0 && notSelected.count < 1
                    self.updateAllPrice()
                    self.tableVIew.reloadData()
                }
            }
        }
        
        CarModel.items = arr
        return arr
    }

    func setupTableView() {
        tableVIew.delegate = self
        
        let nib = UINib(nibName: "CarSectionHeader", bundle: Bundle.main)
        tableVIew.register(nib, forHeaderFooterViewReuseIdentifier: "CarSectionHeader")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.tableVIew.dataArray.count > 0 {
            let arr = self.tableVIew.dataArray.flatMap({$0}) as! [CarModel]
            let notSelected = arr.filter({ !$0.isSelected })
            self.selectAllBtn.isSelected = arr.count > 0 && notSelected.count < 1
        }
        
        if CarVC.needsReload {
            self.tableVIew.beginHeaderRefresh()
            CarVC.needsReload = false
        }
        
        if let nav = self.tabBarController?.viewControllers?.first as? UINavigationController {
            nav.popToRootViewController(animated: true)
        }
        self.updateAllPrice()
    }
    
    func updateAllPrice() {
        if self.tableVIew.dataArray.count < 1 {
            return
        }
        var price = 0.0
        let arr = self.tableVIew.dataArray.flatMap({ $0 }) as! [CarModel]
        for model in arr {
            if model.isSelected {
                switch model.fType {
                case 0, 4 , 5:
                    price += Double(model.fCount) * model.fSalesprice
                case 1, 2:
                    price += Double(model.fCount) * model.fPromotionprice
                case 3:
                    let p = Double(model.fCount) * model.fSalesprice
                    price += p >= model.fPrice ? p - model.fPrice : p
                case 6:
                    price += Double(model.fCount) * model.fSalesprice * (model.fDiscount / 100)
                default:
                    break
                }
            }
        }
        self.allPriceLabel.text = "¥" + price.moneyValue()
    }
    
    private var updateByAllBtn = false
    @IBAction func ac_selectAll(_ sender: UIButton) {
        if !sender.isSelected {
            let arr = self.tableVIew.dataArray.flatMap({ $0 }) as! [CarModel]
            for m in arr {
                if m.fState == 0 {
                    MBProgressHUD.show(errorText: "商品已不在销售状态")
                    return
                }
                if m.fType == 0 {
                    if m.fCount > m.fStock {
                        MBProgressHUD.show(errorText: "库存不足")
                        return
                    }
                } else {
                    if m.fCount + m.fBuycount > m.fPurchasecount {
                        MBProgressHUD.show(errorText: "超过限购数量")
                        return
                    }
                }
            }
        }
        
        sender.isSelected = !sender.isSelected
        if self.tableVIew.dataArray.count < 1 {
            return
        }
        updateByAllBtn = true
        for item in self.tableVIew.dataArray.flatMap({$0}) {
            let model = item as! CarModel
            model.isSelected = sender.isSelected
        }
        self.tableVIew.reloadData()
        updateByAllBtn = false
        self.updateAllPrice()
    }
    
    @IBAction func ac_submit(_ sender: UIButton) {
        if LoginVC.showLogin() || self.tableVIew.dataArray.isEmpty {
            return
        }
        
        let selectedArr = self.tableVIew.dataArray.flatMap({$0})
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CarSectionHeader") as! CarSectionHeader
        let model = carList[section]
        header.titleLabel.text = model.fShopName
        
        header.icon.sd_setImage(with: URL.encodeUrl(string: model.fImgurl), placeholderImage: #imageLiteral(resourceName: "店铺"))
        
        header.selectBtn.isSelected = model.isListSelected
        header.selectAction = { [unowned self] _ in
            for m in model.goodList {
                if m.fState == 0 {
                    MBProgressHUD.show(errorText: "商品已不在销售状态")
                    return
                }
                if m.fType == 0 {
                    if m.fCount > m.fStock {
                        MBProgressHUD.show(errorText: "库存不足")
                        return
                    }
                } else {
                    if m.fCount + m.fBuycount > m.fPurchasecount {
                        MBProgressHUD.show(errorText: "超过限购数量")
                        return
                    }
                }
            }
            
            model.isListSelected = !model.isListSelected
            model.setSelected()
            self.tableVIew.reloadSections([section], with: .none)
        }
        header.selectBtn.isSelected = model.goodList.filter({ !$0.isSelected }).count == 0
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let a = UITableViewRowAction(style: .default, title: "删除") { (action, idx) in
            
            if let model = self.tableVIew.dataArray[indexPath.section][indexPath.row] as? CarModel {
                if !PersonMdel.isLogined() {
                    model.deleteFromDB()
                    self.tableVIew.dataArray[indexPath.section].remove(at: indexPath.row)
                    self.tableVIew.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                    return
                }
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
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
