//
//  PlacehodelTextView.swift
//  caizhu
//
//  Created by wanwu on 16/8/31.
//  Copyright © 2016年 wanwu. All rights reserved.
//

import UIKit

class PlacehodelTextView: UITextView, UITextViewDelegate {
    var placehoderLabel: UILabel?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        steup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steup()
    }
    
    func steup() {
        placehoderLabel?.adjustsFontSizeToFitWidth = true
        placehoderLabel?.textColor = UIColor.hexStringToColor(hexString: "888888")
        placehoderLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(placehoderLabel!)
        self.delegate = self
    }
    
    override var frame: CGRect {
        didSet {
            placehoderLabel = UILabel(frame: bounds)
            placehoderLabel?.frame.size.height = 20
            placehoderLabel?.frame.origin.x += 5
            placehoderLabel?.frame.origin.y += 4
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placehoderLabel?.isHidden = textView.text != ""
    }

}
