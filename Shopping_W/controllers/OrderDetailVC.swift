//
//  OrderDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/5.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderDetailVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64), style: .grouped)
        t.sectionHeaderHeight = 10
        t.estimatedRowHeight = 133
        t.rowHeight = UITableViewAutomaticDimension
        t.dataSource = self
        return t
    } ()
    
    var perOrder: PreCreateOrder = PreCreateOrder()
    
    //就是这么任性，纯代码写的，，，
    var showPayBtn = false
    let totalPriceLabel = UILabel()
    
    var carModels: [CarModel]?
    var useIntegral = false
    var fIntegral = 0//可用积分
    var fIntegralamount = 0.0
    
    var orderModel: OrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "订单详情"
        self.tableView.delegate = self
        self.view.addSubview(tableView)
        
        if showPayBtn && carModels != nil {
            tableView.frame.size.height -= 51
            setupPayBack()
        }
        
        self.setupData()
        requestData()
    }
    
    func requestData() {
        if carModels != nil {
            let ids = carModels!.map({ "\($0.fId),\($0.fCount)" }).joined(separator: "|")
            
            NetworkManager.requestTModel(params: ["method":"apiPreCreateOrderNew", "cartIDs":ids]).setSuccessAction { (bm: BaseModel<PreCreateOrder>) in
                bm.whenSuccess {
                    let model = bm.t!
                    self.perOrder = model
                    let total = CustomTableViewCellItem().build(text: "总价").build(detailText: "¥\(model.saleAmount.moneyValue())").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
                    //运费
                    let freight = CustomTableViewCellItem().build(text: "运费").build(detailText: "¥\(model.payFreight.moneyValue())").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
                    
                    let discount = CustomTableViewCellItem().build(text: "优惠及折扣").build(detailText: "¥\(model.deDuction.moneyValue())").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
                    
                    self.totalPriceLabel.text = "¥\(model.payAmount.moneyValue())"
                    
                    self.tableView.dataArray[3][0] = total
                    self.tableView.dataArray[3][1] = freight
                    self.tableView.dataArray[4][0] = discount
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3), IndexPath(row: 1, section: 3), IndexPath(row: 2, section: 2), IndexPath(row: 0, section: 4)], with: .automatic)
                }
            }
        }
    }
    
    func setupPayBack() {
        let bk = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        bk.backgroundColor = UIColor.white
        view.addSubview(bk)
        
        let l1 = UILabel()
        l1.text = "合计："
        l1.font = UIFont.systemFont(ofSize: 15)
        l1.textColor = UIColor.hexStringToColor(hexString: "888888")
        bk.addSubview(l1)
        
        l1.snp.makeConstraints { (make) in
            make.left.equalTo(bk.snp.left).offset(15)
            make.centerY.equalTo(bk.snp.centerY)
            make.width.height.greaterThanOrEqualTo(20)
        }
        
        
        totalPriceLabel.font = UIFont.systemFont(ofSize: 15)
        totalPriceLabel.textColor = CustomValue.common_red
        bk.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(l1.snp.right).offset(2)
            make.centerY.equalTo(bk.snp.centerY)
            make.width.height.greaterThanOrEqualTo(20)
        }
        
        let btn = UIButton(type: .system)
        btn.backgroundColor = CustomValue.common_red
        btn.layer.cornerRadius = CustomValue.btnCornerRadius
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("立即支付", for: .normal)
        btn.addTarget(self, action: #selector(OrderDetailVC.ac_pay), for: .touchUpInside)
        
        bk.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(bk.snp.right).offset(-15)
            make.height.equalTo(34)
            make.width.equalTo(80)
            make.centerY.equalTo(bk)
        }
    }
    
    func ac_pay() {
        let isUseIntegral = self.useIntegral ? 1 : 0
        if let order = orderModel {
            let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: PayWayVC.self) as! PayWayVC
            vc.orderModel = order
            vc.useIntegral = useIntegral
            vc.fIntegral = self.fIntegral
            vc.totalPrice = self.totalPriceLabel.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let addressModel = self.tableView.dataArray[0][0] as! AddressModel
        if addressModel.fAddressid == 0 {
            MBProgressHUD.show(errorText: "请先选择收货地址")
            return
        }
        MBProgressHUD.show()
        //        var cartIds = carModels!.reduce("", { (r, m) -> String in
        //            return r + "\(m.fId),"
        //        })
        //        cartIds = cartIds.substring(to: cartIds.index(cartIds.endIndex, offsetBy: -1))
        
        let params = ["method":"apiCreateOrder", "isUseIntegral":isUseIntegral, "useIntegral":self.fIntegral, "address":addressModel.fAddress, "addressname":addressModel.fName, "phone":addressModel.fPhone, "addressID":addressModel.fAddressid] as [String : Any]
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hideHUD()
            bm.whenSuccess {
                let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: PayWayVC.self)
                vc.preOrderModel = self.perOrder
                vc.useIntegral = self.useIntegral
                vc.fIntegral = self.fIntegral
                vc.totalPrice = self.totalPriceLabel.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }) { (err) in
            MBProgressHUD.hideHUD()
        }
        
    }
    
    func setupData() {
        let addr = AddressModel().build(cellClass: Address_reciveCell.self).build(isFromStoryBord: false)
        //积分
        let integral = CustomTableViewCellItem().build(heightForRow: 50).build(cellClass: RightTitleCell.self).build(text: "使用积分抵扣").build(accessoryType: .disclosureIndicator)
        let total = CustomTableViewCellItem().build(text: "总价").build(detailText: "¥0").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
        //运费
        let freight = CustomTableViewCellItem().build(text: "运费").build(detailText: "¥0").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
        
        let discount = CustomTableViewCellItem().build(text: "优惠及折扣").build(detailText: "¥0").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
        
        var arr = [CarModel]()
        if let models = carModels {
            arr = models.map({ (model) -> CarModel in
                let carModel = CarModel()
                carModel.build(cellClass: OrerListCell.self).build(heightForRow: 118)
                //模型是从上个tableView传过来的，所以不要影响原来的数据
                carModel.fId = model.fId
                carModel.fCount = model.fCount
                carModel.fSalesprice = model.fSalesprice
                carModel.fGoodsname = model.fGoodsname
                carModel.fGoodimg = model.fGoodimg
                carModel.fExstring = model.fExstring
                carModel.fGoodsid = model.fGoodsid
                carModel.fPromotionid = model.fPromotionid
                return carModel
            })
        } else {
            guard let order = orderModel else { return }
            var price = 0.0
            arr = order.orderEx.map({ (model) -> CarModel in
                let carModel = CarModel()
                carModel.build(cellClass: OrerListCell.self).build(heightForRow: 118)
                //模型是从上个tableView传过来的，所以不要影响原来的数据
                //                carModel.fId = model.fGoodsid
                carModel.fCount = model.fCount
                carModel.fSalesprice = model.fUnitprice
                carModel.fGoodsname = model.fGoodsname
                carModel.fGoodimg = model.fUrl
                carModel.fExstring = model.fSpecifications
                carModel.fGoodsid = model.fGoodsid
                carModel.fPromotionid = order.fPromotionid
//                carModel.fPromotionprice = model.
                
                price += model.fExpayamount
                return carModel
            })
            total.detailText = String(format: "￥%.2f", price)
            freight.detailText = String(format: "￥%.2f", order.fPaidfreight)
            discount.detailText = String(format: "￥%.2f", order.fConcessions)
            self.fIntegral = order.fIntegral
            self.fIntegralamount = order.fIntegralamount
            self.totalPriceLabel.text = "¥\((order.fSaleamount + order.fPaidfreight + order.fConcessions).moneyValue())"
        }
        
        if let ad = AddressModel.defaultAddress {
            ad.build(cellClass: Address_reciveCell.self).build(isFromStoryBord: false)
            tableView.dataArray = [[ad], arr, [integral], [total, freight], [discount]]
        } else {
            tableView.dataArray = [[addr], arr, [integral], [total, freight], [discount]]
        }
    }
    
    
    deinit {
        print("dasdasd")
    }
    
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.tableView.dataArray[indexPath.section][indexPath.row]
        let identifier = (NSStringFromClass(model.cellClass) as NSString).pathExtension
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let customCell = (cell as! CustomTableViewCell)
        customCell.model = model
        
        if let cell = cell as? OrerListCell {
            //            cell.titleLabel.snp.updateConstraints({ (make) in
            //                make.top.equalTo(30)
            //            })
            cell.logisticsBtn.isHidden = true
            cell.reciveBtn.isHidden = true
        } else if let cell = cell as? RightTitleCell, model.text == "使用积分抵扣" {
            cell.selectBtn.isSelected = useIntegral
            cell.selectBtn.isHidden = false
            cell.letftCons.constant = 25
            cell.leftLabel.font = UIFont.boldSystemFont(ofSize: 15)
            
            if self.carModels == nil {
                cell.selectBtn.isHidden = true
                cell.letftCons.constant = 0
            }
            
            //现有积分，可用积分
            var htmlStr = CustomValue.htmlHeader + "<p style='float: right;'>" +
                "<span style='color: black'>积分</span>" +
                "<span style='color: red'>\(fIntegral) </span>" +
                "<span style='color: black'>抵扣</span>" +
                "<span style='color: red'>¥\((abs(fIntegralamount)).moneyValue())</span>" +
                "</p>" + CustomValue.htmlFooter
            if perOrder.IDS != "" {
             htmlStr = CustomValue.htmlHeader + "<p style='float: right;'>" +
                    "<span style='color: black'>现有积分</span>" +
                    "<span style='color: red'>\(perOrder.userIntegral) </span>" +
                    "<span style='color: black'>可用积分</span>" +
                    "<span style='color: red'>\(perOrder.canUseIntegral) </span>" +
                    "<span style='color: black'>抵扣</span>" +
                    "<span style='color: red'>¥\((abs(fIntegralamount)).moneyValue())</span>" +
                    "</p>" + CustomValue.htmlFooter
            }
         
            let htmlData = htmlStr.data(using: .utf8)
            
            let htmlattr = try! NSMutableAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.right
            htmlattr.addAttributes([NSParagraphStyleAttributeName:style], range: NSMakeRange(0, htmlattr.length))
            cell.rightLabel.attributedText = htmlattr
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
//            if orderModel == nil {
//                return
//            }
            let vc = Tools.getClassFromStorybord(sbName: .main, clazz: ReviceAddressVC.self)
            vc.selectedAction = { [unowned self] model in
                self.tableView.dataArray[0][0] = model
                model.build(cellClass: Address_reciveCell.self)
                vc.navigationController?.popViewController(animated: true)
                model.isFromStoryBord = false
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            //            let vc = UseIntegralVCViewController()
            //            vc.submitAction = { [unowned self] num in
            //                self.integral = num
            //                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
            //            }
            //            self.navigationController?.pushViewController(vc, animated: true)
            useIntegral = !useIntegral
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            var price = 0.0
            
            if let order = orderModel {
                price = order.fSaleamount + (useIntegral ? order.fIntegralamount : 0) + order.fPaidfreight + order.fConcessions
            } else {
                price = perOrder.payAmount + (useIntegral ? perOrder.integralAmount : 0) + perOrder.deDuction + perOrder.payFreight
            }
            
            self.totalPriceLabel.text = "¥\(price.moneyValue())"
        } else if indexPath.section == 1 {
            let c = self.tableView.dataArray[1][indexPath.row] as! CarModel
            let vc = Tools.getClassFromStorybord(sbName: .shoppingCar, clazz: GoodsDetailVC.self) as! GoodsDetailVC
            switch c.fType {
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
            vc.promotionid = c.fPromotionid
            vc.goodsId = c.fGoodsid
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }
    
}

