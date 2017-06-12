//
//  LinkedPicker.swift
//  reuseTest
//
//  Created by wanwu on 17/3/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class LinkedPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataArr = NSArray()
    var itemsArr = [[String]]()
    var selectedCoordinates = [SelectedPicker]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.delegate = self
        self.dataSource = self
        let s = readData()
        
        dataArr = try! JSONSerialization.jsonObject(with: s.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSArray
        itemsArr = [[String](), [String](), [String]()]
        
        var names = [String]()
        for item in dataArr {
            let dic = item as! NSDictionary
            names.append(dic["name"] as! String)
        }
        itemsArr[0] = names
        findFor(province: 0, city: 0)
        for i in 0..<3 {
            selectedCoordinates.append(SelectedPicker(component: i, row: 0))
        }
    }
    
    func findFor(province: Int, city: Int) {
        let cityArr = (dataArr[province] as! NSDictionary)["city"] as! NSArray
        var citys = [String]()
        for cityDic in cityArr {
            citys.append((cityDic as! NSDictionary)["name"] as! String)
        }
        itemsArr[1] = citys
        
        if itemsArr.count > 2 {
            itemsArr[2] = (cityArr[city] as! NSDictionary)["area"] as! [String]
        }
        
    }
    
    func readData() -> String {
        do {
            let str = try String(contentsOfFile: Bundle.main.path(forResource: "address", ofType: "txt") ?? "", encoding: String.Encoding.utf8)
            return str
        } catch {
            
        }
        return ""
    }
    
    ///获取当前 选中的
    func getAddressArr() -> [String] {
        var arr = [String]()
        for i in 0..<itemsArr.count {
            let coor = selectedCoordinates[i]
            arr.append(itemsArr[coor.component][coor.row])
        }
        return arr
    }
    
    ///初始化 数据
    func setup(data: [String]) {
        if data.count < itemsArr.count {
            return
        }
        let province = itemsArr[0].index(of: data[0]) ?? 0
        
        findFor(province: province, city: 0)
        let city = itemsArr[1].index(of: data[1]) ?? 0
        findFor(province: province, city: city)
        self.reloadComponent(1)
        self.reloadComponent(2)
        
        self.selectRow(province, inComponent: 0, animated: true)
        self.selectRow(city, inComponent: 1, animated: true)
        
        selectedCoordinates[0].row = province
        selectedCoordinates[1].row = city
        
        if itemsArr.count > 2 {
            let area = self.itemsArr[2].index(of: data[2]) ?? 0
            self.selectRow(area, inComponent: 2, animated: true)
            selectedCoordinates[2].row = area
        }
    }
    
    func findIndex(name: String, component: Int) {
        
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
        return itemsArr.count
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
        
        label.text = itemsArr[component][row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedCoordinates[component].row != row {
            let province = pickerView.selectedRow(inComponent: 0)
            let city = pickerView.selectedRow(inComponent: 1)
            findFor(province: province, city: component > 0 ? city : 0)
            
            for i in component + 1..<itemsArr.count {
                pickerView.reloadComponent(i)
                pickerView.selectRow(0, inComponent: i, animated: true)
            }
            
            selectedCoordinates[component].row = row
        }
    }
}

