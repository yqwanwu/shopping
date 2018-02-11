//
//  AddCardVC.swift
//  Shopping_W
//
//  Created by wanwu on 2018/2/6.
//  Copyright © 2018年 wanwu. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import MBProgressHUD

class AddCardVC: UITableViewController {
    @IBOutlet weak var khLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var xzLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cardNumTF: CheckTextFiled!
    @IBOutlet weak var nameTF: CheckTextFiled!
    @IBOutlet weak var phoneTF: CheckTextFiled!
    
    var bankList = [BankModel]()
    var regions: Results<RegionModel>!
    var province: RegionModel!
    var city: RegionModel!
    var bank: BankModel?
    var selectIndex = 0
    var typeArr = ["对私", "对公"]
    var flagArr = ["储蓄卡", "信用卡"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        province = RegionModel.findAllProvince().first!
        city = RegionModel.findCity(provinceId: province.fRegionid).first!
        provinceLabel.text = province.fName
        cityLabel.text = city.fName
        xzLabel.text = typeArr[0]
        typeLabel.text = flagArr[0]
        requestData()
    }
    
    func requestData()  {
        MBProgressHUD.show()
        NetworkManager.requestListModel(params: ["method":"apibanks"]).setSuccessAction { (bm: BaseModel<BankModel>) in
            MBProgressHUD.hideHUD()
            bm.whenSuccess {
                self.bankList = bm.list!
                self.khLabel.text = self.bankList.first?.fName ?? ""
            }
            }.seterrorAction { (err) in
                MBProgressHUD.hideHUD()
        }
    }

    @IBAction func ac_Submit(_ sender: Any) {
        for tf in [cardNumTF, nameTF, phoneTF] {
            if !tf!.check() {
                MBProgressHUD.show(warningText: "请填写完整信息")
                return
            }
        }
        
        let params = ["method":"apiaddfinance",
                      "fName":self.nameTF.text ?? "",
                      "fBankid":self.bank?.fBankid ?? 0,
                      "fAccount":self.cardNumTF.text ?? "",
                      "fType":self.xzLabel.text! == typeArr[0] ? 0 : 1,
                      "fProvinceid":self.province.fRegionid,
                      "fCityid":self.city.fRegionid,
                      "fFlag":self.typeLabel.text! == flagArr[0] ? 0 : 1,
                      "fPhone":self.phoneTF.text!] as [String : Any]
        NetworkManager.requestTModel(params: params).setSuccessAction { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                MBProgressHUD.show(successText: "添加成功")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegionSelectVC {
            switch self.selectIndex {
            case 0:
                vc.models = self.bankList.map({ $0.fName })
            case 1:
                vc.models = regions.map({ $0.fName })
            case 2:
                vc.models = regions.map({ $0.fName })
            case 3:
                vc.models = self.typeArr
            case 4:
                vc.models = self.flagArr
            default:
                break
            }
            
            vc.selectAction = { [unowned self] idx in
                switch self.selectIndex {
                case 0:
                    self.bank = self.bankList[idx]
                    self.khLabel.text = self.bank!.fName
                case 1:
                    let model = self.regions[idx]
                    self.province = model
                    self.provinceLabel.text = model.fName
                    
                    self.city = RegionModel.findCity(provinceId: model.fRegionid).first!
                    self.cityLabel.text = self.city.fName
                    
                case 2:
                    let model = self.regions[idx]
                    self.city = model
                    self.cityLabel.text = model.fName
                case 3:
                    self.xzLabel.text = self.typeArr[idx]
                case 4:
                    self.typeLabel.text = self.flagArr[idx]
                default:
                    break
                }
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.row {
//        case 1:
//
//        case 2:
//        default:
//            break
//        }
//    }
//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toAlert", sender: self)
        case 1:
            self.regions = RegionModel.findAllProvince()
            self.performSegue(withIdentifier: "toAlert", sender: self)
        case 2:
            self.regions = RegionModel.findCity(provinceId: province.fRegionid)
            self.performSegue(withIdentifier: "toAlert", sender: self)
        case 3:
            self.performSegue(withIdentifier: "toAlert", sender: self)
        case 4:
            self.performSegue(withIdentifier: "toAlert", sender: self)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


class BankModel: CustomTableViewCellItem {
    var fBankid = 0
    var fName = ""//:"中国人民银行"
}

