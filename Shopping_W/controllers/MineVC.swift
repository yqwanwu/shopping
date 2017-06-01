//
//  MineVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/26.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class MineVC: BaseViewController {
    let k_toReceiving = "toReceiving"
    let k_toAddress = "toAddress"
    let k_toIntegral = "toIntegral"
    
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
    }
    
    func setupTableView() {
        //懒得创建新的类，text代表图片名称，detailText代表name
        let c = CustomTableViewCellItem().build(imageUrl: "收藏").build(detailText: "我的收藏")
        let c1 = CustomTableViewCellItem().build(imageUrl: "消费详情").build(detailText: "消费详情")
        let c2 = CustomTableViewCellItem().build(imageUrl: "我的评价").build(detailText: "我的评价")
        let c3 = CustomTableViewCellItem().build(imageUrl: "收货地址").build(detailText: "收货地址")
        let c4 = CustomTableViewCellItem().build(imageUrl: "积分").build(detailText: "积分详情")
        let c5 = CustomTableViewCellItem().build(imageUrl: "浏览记录").build(detailText: "浏览记录")
        
        
        c3.setupCellAction { [unowned self] (idx) in
            self.performSegue(withIdentifier: self.k_toAddress, sender: self)
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
            btn.tag = 1024 + i
            
            if i != 0 {
                let line = UIView(frame: CGRect(x: CGFloat(i) * btnW, y: 15, width: 1, height: 0))
                line.backgroundColor = UIColor.hexStringToColor(hexString: "f4f4f4")
                reciveBk.addSubview(line)
                lines.append(line)
            }
        }
    }
    
    
    func ac_gotoRevice(sender: UIButton) {
        self.performSegue(withIdentifier: k_toReceiving, sender: self)
    }
    

    @IBAction func ac_withdraw(_ sender: UIButton) {
        
    }
 
    @IBAction func ac_reword(_ sender: UIButton) {
        
    }
    
    @IBAction func ac_toSettings(_ sender: UIButton) {
        self.navigationController?.pushViewController(SettingsVC(), animated: true)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == k_toIntegral {
            if let vc = segue.destination as? BalanceVC {
                vc.type = .integral
            }
        }
    }

}













