//
//  MineVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/26.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class MineVC: BaseViewController {
    let k_toReceiving = "toReceiving"
    let k_toAddress = "toAddress"
    let k_toIntegral = "toIntegral"
    let k_toAllRecive = "toAllRecive"
    let k_toBalance = "toBalance"
    
    @IBOutlet weak var tableView: RefreshTableView!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    ///奖励
    @IBOutlet weak var rewardBtn: UIButton!
    ///提现
    @IBOutlet weak var withdrawBtn: UIButton!
    ///积分
    @IBOutlet weak var integralLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var reciveBk: UIView!
    
    var reciveBtns = [UIButton]()
    var lines = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        self.tableView.bounces = false
    }
    
    func setupTableView() {
        //懒得创建新的类，text代表图片名称，detailText代表name
        let c = CustomTableViewCellItem().build(imageUrl: "收藏").build(detailText: "我的收藏")
        let c1 = CustomTableViewCellItem().build(imageUrl: "消费详情").build(detailText: "消费详情")
        let c2 = CustomTableViewCellItem().build(imageUrl: "我的评价").build(detailText: "我的评价")
        let c3 = CustomTableViewCellItem().build(imageUrl: "收货地址").build(detailText: "收货地址")
        let c4 = CustomTableViewCellItem().build(imageUrl: "积分").build(detailText: "积分详情")
        let c5 = CustomTableViewCellItem().build(imageUrl: "浏览记录").build(detailText: "浏览记录")
        
        c.setupCellAction { [unowned self] (idx) in
            let vc = MyCollectionVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        c1.setupCellAction { [unowned self] (idx) in
            self.performSegue(withIdentifier: self.k_toBalance, sender: self)
        }
        c2.setupCellAction { [unowned self] (idx) in
            let vc = MyEvaluateListVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        c3.setupCellAction { [unowned self] (idx) in
            self.performSegue(withIdentifier: self.k_toAddress, sender: self)
        }
        c4.setupCellAction { [unowned self] (idx) in
            self.performSegue(withIdentifier: self.k_toIntegral, sender: self)
        }
        c5.setupCellAction { [unowned self] (idx) in
            let vc = CookiesVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        let datas = [c, c1, c2, c3, c4, c5]
        
        let height = (self.view.frame.width - 2) / 3 * 0.683 * 2 + 1
        let cellData = CustomTableViewCellItem().build(heightForRow: height).build(cellClass: MineTableViewCell.self).build(isFromStoryBord: true).build(customValue: ["datas":datas])
        tableView.dataArray = [[cellData]]
        tableView.sectionHeaderHeight = 10
    }
    
    ///构建4大收货按钮
    func setupUI() {
        let btnW = UIScreen.main.bounds.width / 4
        let imgs = [#imageLiteral(resourceName: "带付款"), #imageLiteral(resourceName: "待收货"), #imageLiteral(resourceName: "待评价"), #imageLiteral(resourceName: "退货")]
        let titles = ["待付款", "待收货", "待评价", "退货"]
        for i in 0..<4 {
            let btn = UIButton(type: .system)
            btn.frame = CGRect(x: btnW * CGFloat(i), y: 0, width: btnW, height: 0)
            reciveBtns.append(btn)
            reciveBk.addSubview(btn)
            
            let img = UIImageView(image: imgs[i])
            img.frame = CGRect(x: btnW / 2 - 16, y: 15, width: 32, height: 30)
            img.contentMode = .scaleAspectFit
            btn.addSubview(img)
            
            let label = UILabel(frame: CGRect(x: 0, y: img.frame.maxY + 8, width: btnW, height: 20))
            label.text = titles[i]
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
            btn.addSubview(label)
            
            btn.addTarget(self, action: #selector(MineVC.ac_gotoRevice(sender:)), for: .touchUpInside)
            
            if i != 0 {
                let line = UIView(frame: CGRect(x: CGFloat(i) * btnW, y: 15, width: 1, height: 0))
                line.backgroundColor = UIColor.hexStringToColor(hexString: "f4f4f4")
                reciveBk.insertSubview(line, at: 0)
                lines.append(line)
            }
            
            let badgeView = BadgeView.create()
            badgeView.center = CGPoint(x: img.frame.maxX, y: img.frame.minY)
            badgeView.tag = 1025
            btn.addSubview(badgeView)
        }
        
        reciveBtns[0].tag = 1024
        reciveBtns[1].tag = 1024 + 2
        reciveBtns[2].tag = 1024 + 3
        reciveBtns[3].tag = 2048
    }
    
    //MARK: 4大点击事件
    var orderIndex = 0
    func ac_gotoRevice(sender: UIButton) {
        let tag = sender.tag - 1023
        if tag > 0 {
            if sender.tag == 2048 {
                let vc = ReturnedVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                orderIndex = tag
                self.performSegue(withIdentifier: k_toReceiving, sender: self)
            }
        }
    }
    
    
    @IBAction func ac_msg(_ sender: Any) {
        let vc = Tools.getClassFromStorybord(sbName: .mine, clazz: MyMsgVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func ac_withdraw(_ sender: UIButton) {
        
    }
 
    @IBAction func ac_reword(_ sender: UIButton) {
        
    }
    
    @IBAction func ac_toSettings(_ sender: UIButton) {
        self.navigationController?.pushViewController(SettingsVC(), animated: true)
    }
    
    func requestCount() {
        NetworkManager.JsonPostRequest(params: ["method":"apimyuserinfostate"], success: { (j) in
            if !j["list"].arrayValue.isEmpty {
                self.balanceLabel.text = "\(j["list"].arrayValue.first!["fAmount"].intValue)"
                self.msgLabel.text = "\(j["list"].arrayValue.first!["fMessaagecount"].intValue)"
                self.integralLabel.text = "\(j["list"].arrayValue.first!["fIntegral"].intValue)"
            }
        }) { (err) in
            
        }
        
        NetworkManager.JsonPostRequest(params: ["method":"apimyorderstates"], success: { (j) in

            if !j["list"].arrayValue.isEmpty {
                (self.reciveBtns[0].viewWithTag(1025) as! BadgeView).badgeValue = self.getCountStr(j: j, name: "fPendingpay")
                (self.reciveBtns[1].viewWithTag(1025) as! BadgeView).badgeValue = self.getCountStr(j: j, name: "fPendingreceive")
                (self.reciveBtns[2].viewWithTag(1025) as! BadgeView).badgeValue = self.getCountStr(j: j, name: "fPendingappraisal")
                (self.reciveBtns[3].viewWithTag(1025) as! BadgeView).badgeValue = self.getCountStr(j: j, name: "fReturncount")
            }
        }) { (err) in
            
        }
    }
    
    func getCountStr(j: JSON, name: String) -> String? {
        let n = j["list"].arrayValue.first![name].intValue
        return n == 0 ? nil : "\(n)"
    }
    
    //MARK: 重写
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headImg.layer.cornerRadius = headImg.frame.width / 2
        rewardBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        withdrawBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        
        for btn in reciveBtns {
            btn.frame.size.height = reciveBk.frame.height
        }
        
        for line in lines {
            line.frame.size.height = self.reciveBk.frame.height - 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let person = PersonMdel.readData() {
            headImg.sd_setImage(with: URL.encodeUrl(string: person.fHeadImgUrl), placeholderImage: #imageLiteral(resourceName: "默认头像-方@2x"))
            self.nameLabel.text = person.fNickname
            self.phoneLabel.text = person.fPhone
        }
        
        requestCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let identifier = segue.identifier
        
        if identifier == k_toIntegral {
            if let vc = segue.destination as? BalanceVC {
                vc.type = .integral
            }
        } else if identifier == k_toBalance {
            if let vc = segue.destination as? BalanceVC {
                vc.totalBalance = self.balanceLabel.text ?? ""
            }
        }else if identifier == k_toAllRecive {
            orderIndex = 0
        } else if identifier == k_toReceiving {
            let vc = segue.destination as! OrderVC
            vc.selectedIndex = orderIndex
        }
    }

}













