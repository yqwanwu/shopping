//
//  LinkedPicker.swift
//  reuseTest
//
//  Created by wanwu on 17/3/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import RealmSwift
import MBProgressHUD

class LinkedPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataArr = NSArray()
    var itemsArr = [Results<RegionModel>]()
    var selectedCoordinates = [SelectedPicker]()
    
    var allProvince = RegionModel.findAllProvince()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if allProvince.count < 1 {
            MBProgressHUD.show()
            RegionModel.requestData(compalete: {
                MBProgressHUD.hideHUD()
                self.allProvince = RegionModel.findAllProvince()
                if self.allProvince.count < 1 {
                    MBProgressHUD.show(errorText: "请求失败")
                } else {
                    self.setupUI()
                }
            })
        } else {
            setupUI()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if allProvince.count < 1 {
            MBProgressHUD.show()
            RegionModel.requestData(compalete: {
                MBProgressHUD.hideHUD()
                self.allProvince = RegionModel.findAllProvince()
                if self.allProvince.count < 1 {
                    MBProgressHUD.show(errorText: "请求失败")
                } else {
                    self.setupUI()
                }
            })
        } else {
            setupUI()
        }
    }
    
    func setupUI() {
        self.delegate = self
        self.dataSource = self
        self.isMultipleTouchEnabled = false
        
        itemsArr.append(allProvince)
        let provinceModel = itemsArr[0][0]
        itemsArr.append(RegionModel.findCity(provinceId: provinceModel.fRegionid))
        let cityModel = itemsArr[1][0]
        itemsArr.append(RegionModel.findArea(cityId: cityModel.fRegionid))
        
        for i in 0..<3 {
            selectedCoordinates.append(SelectedPicker(component: i, row: 0))
        }
    }
    
    ///获取当前 选中的
    func getAddressArr() -> [String] {
        var arr = [String]()
        for i in 0..<itemsArr.count {
            let coor = selectedCoordinates[i]
            arr.append(itemsArr[coor.component][coor.row].fName)
        }
        return arr
    }
    
    ///初始化 数据
    func setup(data: [String]) {
        if data.count < itemsArr.count {
            return
        }
        
        var province = 0
        for i in 0..<allProvince.count {
            let p = allProvince[i]
            if p.fName.contains(data[0]) {
                province = i
                self.itemsArr[1] = RegionModel.findCity(provinceId: p.fRegionid)
                break
            }
        }
        
        var city = 0
        for i in 0..<itemsArr[1].count {
            let p = itemsArr[1][i]
            if p.fName.contains(data[1]) {
                city = i
                self.itemsArr[2] = RegionModel.findArea(cityId: p.fRegionid)
                break
            }
        }
        
        self.reloadComponent(1)
        self.reloadComponent(2)
        
        self.selectRow(province, inComponent: 0, animated: true)
        self.selectRow(city, inComponent: 1, animated: true)
        
        selectedCoordinates[0].row = province
        selectedCoordinates[1].row = city
        
        if itemsArr.count > 2 {
            var area = 0
            for i in 0..<itemsArr[2].count {
                let p = itemsArr[2][i]
                if p.fName.contains(data[2]) {
                    area = i
                    break
                }
            }
            self.selectRow(area, inComponent: 2, animated: true)
            selectedCoordinates[2].row = area
        }
    }
    
    
    struct SelectedPicker {
        var component = 0
        var row = 0
        
        init(component: Int, row: Int) {
            self.component = component
            self.row = row
        }
    }
    
}

extension LinkedPicker {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsArr[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        if view == nil {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width / CGFloat(itemsArr.count), height: 44))
        } else {
            label = view as! UILabel
        }
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.adjustsFontSizeToFitWidth = true
        
        label.text = itemsArr[component][row].fName
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedCoordinates[component].row != row {
            let provinceIdx = pickerView.selectedRow(inComponent: 0)
            let cityIdx = pickerView.selectedRow(inComponent: 1)
            
            let provinceModel = itemsArr[0][provinceIdx]
            itemsArr[1] = RegionModel.findCity(provinceId: provinceModel.fRegionid)
            if itemsArr[1].count < 1 {
                return
            }
            let cityModel = itemsArr[1][itemsArr[1].count > cityIdx ? cityIdx : 0]
            itemsArr[2] = RegionModel.findArea(cityId: cityModel.fRegionid)
            
            for i in component + 1..<itemsArr.count {
                pickerView.reloadComponent(i)
                pickerView.selectRow(0, inComponent: i, animated: true)
            }
            
            selectedCoordinates[component].row = row
        }
    }
}

