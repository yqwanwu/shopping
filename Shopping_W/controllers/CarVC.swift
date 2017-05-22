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

    @IBOutlet weak var allPriceLabel: UILabel!
    @IBOutlet weak var selectAllBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    func setupTableView() {
        let c = CustomTableViewCellItem()
            .build(cellClass: CarTableViewCell.self)
            .build(isFromStoryBord: true)
            .build(heightForRow: 137)
        tableVIew.dataArray = [[c, c, c], [c, c]]
        tableVIew.delegate = self
    }
    
    
    
    @IBAction func ac_selectAll(_ sender: UIButton) {
    }
    
    @IBAction func ac_submit(_ sender: UIButton) {
    }
    
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nib = UINib(nibName: "CarSectionHeader", bundle: Bundle.main)
        let header = nib.instantiate(withOwner: nil, options: nil).first as! CarSectionHeader
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
}
