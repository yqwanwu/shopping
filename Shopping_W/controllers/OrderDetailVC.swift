//
//  OrderDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/5.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class OrderDetailVC: BaseViewController, UITableViewDataSource {

    lazy var tableView: CustomTableView = {
        let t = CustomTableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64), style: .grouped)
        t.sectionHeaderHeight = 10
        t.estimatedRowHeight = 133
        t.rowHeight = UITableViewAutomaticDimension
        t.dataSource = self
        return t
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "订单详情"
        
        self.view.addSubview(tableView)
        setupData()
    }
    
    
    func setupData() {
        let addr = CustomTableViewCellItem().build(cellClass: Address_reciveCell.self)
        let goods = CustomTableViewCellItem().build(cellClass: OrerListCell.self).build(heightForRow: 118)
        //积分
        let integral = CustomTableViewCellItem().build(heightForRow: 50).build(cellClass: RightTitleCell.self).build(text: "使用积分抵扣")
        let total = CustomTableViewCellItem().build(text: "总价").build(detailText: "¥1232").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
        //运费
        let freight = CustomTableViewCellItem().build(text: "运费").build(detailText: "¥1232").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
        
        let discount = CustomTableViewCellItem().build(text: "优惠及折扣").build(detailText: "¥1232").build(heightForRow: 50).build(cellClass: RightTitleCell.self)
    
        tableView.dataArray = [[addr], [goods], [integral], [total, freight], [discount]]
    }
    
    
    
    //MARK: 代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.tableView.dataArray[indexPath.section][indexPath.row]
        let identifier = (NSStringFromClass(model.cellClass) as NSString).pathExtension
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let customCell = (cell as! CustomTableViewCell)
        customCell.model = model
        
        if let cell = cell as? OrerListCell {
            cell.titleLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(30)
            })
            cell.logisticsBtn.isHidden = true
            cell.reciveBtn.isHidden = true
        } else if let cell = cell as? RightTitleCell, model.text == "使用积分抵扣" {
            cell.leftLabel.font = UIFont.boldSystemFont(ofSize: 15)
            let htmlStr = CustomValue.htmlHeader + "<p style='float: right;'>" +
                "<span style='color: black'>积分</span>" +
                "<span style='color: red'>50 </span>" +
                "<span style='color: black'>抵扣</span>" +
                "<span style='color: red'>¥5</span>" +
                "</p>" + CustomValue.htmlFooter
            let htmlData = htmlStr.data(using: .utf8)
            
            let htmlattr = try! NSMutableAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.right
            htmlattr.addAttributes([NSParagraphStyleAttributeName:style], range: NSMakeRange(0, htmlattr.length))
            cell.rightLabel.attributedText = htmlattr
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }
    
}
