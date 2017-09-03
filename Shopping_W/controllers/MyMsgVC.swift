//
//  MyMsgVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/8/31.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class MyMsgVC: BaseViewController {
    @IBOutlet weak var tableView: RefreshTableView!
    var curentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addHeaderAction { [unowned self] _ in
            self.curentPage = 1
            self.reqestData()
        }
        
        tableView.addFooterAction { [unowned self] _ in
            self.curentPage += 1
            self.reqestData()
        }
        
        tableView.beginHeaderRefresh()
    }
    
    func reqestData() {
        NetworkManager.requestPageInfoModel(params: ["method":"apimyConsultList"]).setSuccessAction { (bm: BaseModel<MyMsgModel>) in
            self.tableView.endHeaderRefresh()
            self.tableView.endFooterRefresh()
            
            bm.whenSuccess {
                var arr = bm.pageInfo!.list!.map({ (model) -> MyMsgModel in
                    model.build(cellClass: MyMsgCell.self).build(isFromStoryBord: true)
                    return model
                })
                if self.curentPage > 1 {
                    arr.insert(contentsOf: self.tableView.dataArray[0] as! [MyMsgModel], at: 0)
                }
                
                if !bm.pageInfo!.hasNextPage {
                    self.tableView.noMoreData()
                }
                
                self.tableView.dataArray = [arr]
                self.tableView.reloadData()
            }
        }.seterrorAction { (err) in
            self.tableView.endHeaderRefresh()
            self.tableView.endFooterRefresh()
        }
    }

}


class MyMsgModel: CustomTableViewCellItem {
    var fId = 0//id
    var fReplyusername = ""//回复管理员
    var fReplycontent = ""//回复内容
    var fContent = ""//咨询内容
    var fConsulttime = 0.0//咨询时间
    var fReplytime = 0.0//回复时间
    var fGoodsname = ""//标题
}

class MyMsgCell: CustomTableViewCell {
    
    @IBOutlet weak var questionTimeLabel: UILabel!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var replyName: UILabel!
    @IBOutlet weak var replyContent: UILabel!
    @IBOutlet weak var replyTimeLabel: UILabel!

    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? MyMsgModel {
                goodsNameLabel.text = "商品名称" + m.fGoodsname
                questionLabel.text = "咨询内容" + m.fContent
                replyName.text = m.fReplyusername
                replyContent.text = m.fReplycontent
                
                let fmt = DateFormatter()
                fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                questionLabel.text = fmt.string(from: Date(timeIntervalSince1970: m.fConsulttime / 1000))
                replyTimeLabel.text = fmt.string(from: Date(timeIntervalSince1970: m.fReplytime / 1000))
            }
        }
    }
}
