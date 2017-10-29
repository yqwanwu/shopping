//
//  AboutVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/10/8.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    @IBOutlet weak var textVieiw: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "关于"
        
        textVieiw.text = "        重整网是由天津市博晟泽科技发展有限公司为重整集团股份有限公司定制的一款(F2C,C2I,O2P)购物平台。\n        重整购物平台是一款集母婴玩具、办公文娱、五金化工、本地服务、美食生鲜、家电数码、日用家居、个人护理、服务饰品、户外运动于一体的购物软件。价格实惠，品种齐全。您可以在重整网中尽情享受购物过程，体验不一样的购物！"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
