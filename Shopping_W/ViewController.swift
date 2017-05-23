//
//  ViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/16.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    @IBOutlet weak var titleBack: UIView!
    @IBOutlet weak var searchBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleBack.bounds.size.width = self.view.frame.width - 40
        searchBtn.layer.cornerRadius = 6
    }

    @IBAction func ac_address(_ sender: Any) {
        
    }
    
    //MARK: 重写
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.titleBack.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleBack.isHidden = false
    }
    
    
    //MARK: 代理

}

