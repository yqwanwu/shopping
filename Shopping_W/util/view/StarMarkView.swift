//
//  StarMarkView.swift
//  someDemo
//
//  Created by wanwu on 2017/5/24.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

/**
 *  五角星评分视图
 */
class StarMarkView: UIView {
    
    var isPanGestureEnable = true
    var isTapGestureEnable = true
    var isFullStar = false
    
    var score: CGFloat = 5.0 {
        didSet {
            setLength()
        }
    }

    var starCount = 5 {
        didSet {
            setup()
        }
    }
    var sadImg: UIImage? {
        didSet {
            if let img = sadImg {
                for iv in sadStarList {
                    iv.image = img
                }
            }
        }
    }
    
    var likeImg: UIImage? {
        didSet {
            if let img = likeImg {
                for iv in likeStarList {
                    iv.image = img
                }
            }
        }
    }
    
    private var likeBackView = UIView()
    
    var margin: CGFloat = 10.0
    
    var sadStarList = [UIImageView]()
    var likeStarList = [UIImageView]()
    
    let maskLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        for i in 0..<sadStarList.count {
            sadStarList[i].removeFromSuperview()
            likeStarList[i].removeFromSuperview()
        }
        sadStarList.removeAll()
        likeStarList.removeAll()
        for _ in 0..<starCount {
            let sadImgV = UIImageView()
            let likeImgV = UIImageView()
            sadImgV.contentMode = .scaleAspectFit
            likeImgV.contentMode = .scaleAspectFit
            
            addSubview(sadImgV)
            sadStarList.append(sadImgV)
            likeStarList.append(likeImgV)
        }
        
        addSubview(likeBackView)
        likeBackView.isUserInteractionEnabled = false
        
        for l in likeStarList {
            likeBackView.addSubview(l)
        }

        let pan = UIPanGestureRecognizer(target: self, action: #selector(StarMarkView.ac_pan(sender:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(StarMarkView.ac_tap(sender:)))
        
        self.addGestureRecognizer(pan)
        self.addGestureRecognizer(tap)
        
        likeBackView.layer.mask = maskLayer
        maskLayer.backgroundColor = UIColor.red.cgColor
    }
    
    func ac_pan(sender: UIPanGestureRecognizer) {
        if !isPanGestureEnable {
            return
        }
        
        let point = sender.location(in: self)
        let length = sadStarList.last?.frame.maxX ?? 1
        
        score = (point.x / length) * CGFloat(sadStarList.count)
    }
    
    func ac_tap(sender: UITapGestureRecognizer) {
        if !isTapGestureEnable {
            return
        }
        let point = sender.location(in: self)
        let length = sadStarList.last?.frame.maxX ?? 1
        
        score = (point.x / length) * CGFloat(sadStarList.count)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        likeBackView.frame = self.bounds
        
        if sadStarList.isEmpty {
            setup()
        }
        
        var w = (self.frame.width - margin * CGFloat(starCount - 1)) / CGFloat(starCount)
        w = w < self.frame.height ? w : self.frame.height
        let y = (self.frame.height - w) / 2
        for i in 0..<starCount {
            let f = CGRect(x: CGFloat(i) * (margin + w), y: y, width: w, height: self.frame.height)
            sadStarList[i].frame = f
            likeStarList[i].frame = f
        }
        
        setLength()
    }
    
    func setLength() {
        let length = sadStarList.last?.frame.maxX ?? 1
        maskLayer.frame = likeBackView.frame
        maskLayer.frame.size.width = (isFullStar ? ceil(score) : score) / CGFloat(sadStarList.count) * length
    }

}
