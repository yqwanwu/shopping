//
//  AddressVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/22.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class AddressVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var topBack: UIView!
    @IBOutlet weak var tableVIew: CustomTableView!
    
    let hotCitys = ["北京", "上海", "深圳", "成都", "广州", "湖南"]
//    let hotCitysForTableView = ["北京", "上海", "深圳", "成都", "广州", "湖南", "绵阳", "天津", "河北", "雅安", "峨眉", "达州", "德阳", "北川"]
    
    static let hotCitysForTableView: [String] = {
        let str = try! String(contentsOfFile: Bundle.main.path(forResource: "address", ofType: "txt") ?? "", encoding: String.Encoding.utf8)
        let dataArr = try! JSONSerialization.jsonObject(with: str.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSArray
        let cityArr = (dataArr[0] as! NSDictionary)["city"] as! NSArray
        var citys = [String]()
        
        for city in dataArr {
            for cityDic in (city as! NSDictionary)["city"] as! NSArray {
                citys.append((cityDic as! NSDictionary)["name"] as! String)
            }
        }
        
        return citys
    } ()
    
    let indexArr: [String] = {
        var arr = [String]()
        for i in 0..<26 {
            let c = Character(UnicodeScalar(Int(UnicodeScalar("A").value) + i)!)
            arr.append(String(c))
        }
        return arr
    } ()
    var topHotBtns = [UIButton]()
    var sortedNameTuple = [(key: String, value: [String])]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTopHot()
        
        tableVIew.sectionIndexColor = UIColor.white
        tableVIew.sectionIndexBackgroundColor = UIColor.hexStringToColor(hexString: "7f7f7f")
        
        setupData()
    }

    func createTopHot() {
        for t in hotCitys {
            let btn = UIButton(type: .system)
            btn.backgroundColor = CustomValue.common_red
            btn.layer.cornerRadius = CustomValue.btnCornerRadius
            btn.layer.masksToBounds = true
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitle(t, for: .normal)
            self.topBack.addSubview(btn)
            topHotBtns.append(btn)
        }
        topBack.setNeedsLayout()
        topBack.layoutIfNeeded()
    }
    
    func setupData() {
        var cityNamesMap = [String: [String]]()
        for name in AddressVC.hotCitysForTableView {
            let pinYin = Tools.getPinyinHead(str: name)
            if let arr = cityNamesMap[pinYin] {
                var newArr = [name]
                newArr.append(contentsOf: arr)
                cityNamesMap[pinYin] = newArr
            } else {
                cityNamesMap[pinYin] = [name]
            }
        }
        
        sortedNameTuple = cityNamesMap.sorted(by: { (p1: (key: String, value: [String]), p2: (key: String, value: [String])) -> Bool in
            return p1.key <  p2.key
        })
    }
    
    //MARK: 重写
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let btnW: CGFloat = 90
        let btnH: CGFloat = 30
        let wspace = (topBack.frame.width - btnW * 3) / 4
        let hspace = (topBack.frame.height - btnH * 2) / 3
        var i = 0
        for btn in topHotBtns {
            btn.frame = CGRect(x: wspace + (btnW + wspace) * CGFloat(i % 3), y: hspace + (btnH + hspace) * CGFloat(i / 3), width: btnW, height: btnH)
            i += 1
        }
    }
    
    //MARK: 代理
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexArr
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedNameTuple[section].key
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedNameTuple.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedNameTuple[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sortedNameTuple[indexPath.section].value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
