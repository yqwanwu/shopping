//
//  WelcomeVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/10/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeVC: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let pc = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self.view)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: 0)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 1...3 {
            let imgView = UIImageView()
            scrollView.addSubview(imgView)
            imgView.contentMode = .scaleToFill
            imgView.image = UIImage(named: "index\(i)")
            imgView.snp.makeConstraints({ (make) in
                make.left.equalTo(scrollView).offset(CGFloat(i - 1) * UIScreen.main.bounds.width)
                make.top.bottom.equalTo(scrollView)
                make.width.equalToSuperview()
                if i == 3 {
                    make.right.equalToSuperview()
                    imgView.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(ac_enter))
                    imgView.addGestureRecognizer(tap)
                }
                make.height.equalToSuperview()
            })
            
//            if i == 2 {
//                let btn = UIButton(type: .system)
//                btn.addTarget(self, action: #selector(ac_enter), for: .touchUpInside)
//                imgView.addSubview(btn)
//                btn.snp.makeConstraints({ (make) in
//                    make.bottom.equalToSuperview().offset(-70)
//                    make.centerX.equalToSuperview()
//                    make.height.equalTo(46)
//                    make.width.equalTo(100)
//                })
//                btn.layer.cornerRadius = 23
//                btn.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
//                btn.setTitle("立即体验", for: .normal)
//            }
        }
        
        //pageControl
//        pc.numberOfPages = 3
//        view.addSubview(pc)
//        pc.snp.makeConstraints { (make) in
//            make.left.right.equalTo(self.view)
//            make.height.equalTo(30)
//            make.bottom.equalToSuperview().offset(-30)
//        }
    }
    
    func ac_enter() {
        let vc = Tools.getClassFromStorybord(sbName: .main, clazz: CustomTabBarVC.self)
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: dlegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pc.currentPage = Int((scrollView.contentOffset.x / UIScreen.main.bounds.width) + 0.45)
    }


}










