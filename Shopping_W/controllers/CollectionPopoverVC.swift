//
//  CollectionPopoverVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class CollectionPopoverVC: BaseViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: CustomTableView!
    
    weak var parentVC: UIViewController?
    var goodsId = 0
    var promotionid = 0
    var shareText = ""
    var detailModel = GoodsDetailModel()
    
    var goodsImg: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        let c = CustomTableViewCellItem().build(cellClass: NormalTableViewCell.self).build(text: "收藏").build(heightForRow: 45)
        c.setupCellAction { (idx) in
            debugPrint("收藏")
        }
        
        let c1 = CustomTableViewCellItem().build(cellClass: NormalTableViewCell.self).build(text: "分享").build(heightForRow: 45)
        c1.setupCellAction { (idx) in
            debugPrint("分享")
        }
        tableView.dataArray = [[c, c1]]
        
        tableView.delegate = self
        
    }
    
    var selectedIndex = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if PersonMdel.isLogined() {
                addToCollection()
            } else {
                
            }
            break
        case 1:
            var url = ""
            if let pic = detailModel.picList?.first?["fUrl"] as? String {
                url = URL.encodeUrl(string: pic)?.absoluteString ?? ""
            }
            
            var link = "http://www.cz928.com/Share?share=goods/\(detailModel.fGoodsid)?"//action=1&fPromotionid=32&q=-1
            if let u = PersonMdel.readData() {
                link += "q=\(u.fAccountid)"
            } else {
                link += "q=-1"
            }
            
            if detailModel.fType > 0 {
                link += "&action=\(detailModel.fType)&fPromotionid=\(detailModel.fPromotionid)"
            }
            
            if let gi = goodsImg {
                ThirdLoginOrShare.show(viewController: parentVC!, title: detailModel.fGoodsname, text: detailModel.fSummary, img: gi, url: link)
            } else {
                ThirdLoginOrShare.show(viewController: parentVC!, title: detailModel.fGoodsname, text: detailModel.fSummary, img: url, url: link)
            }
            selectedIndex = 1
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    func addToCollection() {
        var params = ["method":"apiFavoritesAdd"]
        params["fGoodsid"] = "\(goodsId)"
        if promotionid != 0 {
            params["fPromotionid"] = "\(promotionid)"
        }
        NetworkManager.requestTModel(params: params).setSuccessAction { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                MBProgressHUD.show(successText: "收藏成功")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if selectedIndex == 0 {
            LoginVC.showLogin()
        }
    }
    

}
