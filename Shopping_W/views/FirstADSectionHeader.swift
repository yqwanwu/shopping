//
//  FirstADSectionHeader.swift
//  Shopping_W
//
//  Created by wanwu on 2017/8/20.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class FirstADSectionHeader: UICollectionReusableView {
    @IBOutlet weak var imgView: UIImageView!
    
    var tapAction: BLANK_CLOSURE?
    weak var topVC: UIViewController?
    var urlStr = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func ac_click(_ sender: Any) {
        tapAction?()
        
        let web = BaseWebViewController()
        web.url = urlStr
        topVC?.navigationController?.pushViewController(web, animated: true)
    }
    
}
