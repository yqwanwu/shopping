//
//  MyEvaluateVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

///商品评价，不是列表，名字整错了
class MyEvaluateVC: BaseViewController {
    @IBOutlet weak var starView: StarMarkView!
    @IBOutlet weak var textView: PlacehodelTextView!
    @IBOutlet weak var submitBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        starView.sadImg = #imageLiteral(resourceName: "p4.6.1.1-评价-灰.png")
        starView.likeImg = #imageLiteral(resourceName: "p4.6.1.1-评价-红.png")
        starView.margin = 8
        textView.layer.cornerRadius = CustomValue.btnCornerRadius
        textView.placeholderText = "请输入评价内容"
        textView.placehoderLabel?.text = "请输入评价内容"
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        
        view.backgroundColor = UIColor.white
    }

    @IBAction func ac_submit(_ sender: Any) {
    }
}
