//
//  MyEvaluateVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

///商品评价，不是列表，名字整错了
class MyEvaluateVC: BaseViewController {
    @IBOutlet weak var starView: StarMarkView!
    @IBOutlet weak var textView: PlacehodelTextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var orderModel: OrderModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        starView.sadImg = #imageLiteral(resourceName: "p4.6.1.1-评价-灰.png")
        starView.likeImg = #imageLiteral(resourceName: "p4.6.1.1-评价-红.png")
        starView.margin = 8
        starView.isFullStar = true
        textView.layer.cornerRadius = CustomValue.btnCornerRadius
        textView.placeholderText = "请输入评价内容"
        textView.placehoderLabel?.text = "请输入评价内容"
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        
        view.backgroundColor = UIColor.white
    }

    @IBAction func ac_submit(_ sender: Any) {
//        method	string	apieditevaluation	无
//        fGoodsid	int	前台获取	商品ID
//        fOrderid	int	前台获取	订单ID
//        fStar	int	前台获取	评价星数
//        fContent	string	前台获取	评价内容
//        fEvaluationid	int	前台获取	评价ID,存在值为修改，否则为添加
        let score = Int(starView.score)
        let params = ["method":"apieditevaluation", "fGoodsid":orderModel.orderEx[0].fGoodsid, "fOrderid":orderModel.fOrderid, "fStar":score, "fContent":textView.text ?? ""] as [String : Any]
        MBProgressHUD.show()
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hideHUD()
            bm.whenSuccess {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            MBProgressHUD.hideHUD()
            MBProgressHUD.show(errorText: "请求失败")
        }
        
    }
}
