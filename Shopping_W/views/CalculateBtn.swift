//
//  CalculateBtn.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/17.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import SnapKit

///购物车的计算按钮
class CalculateBtn: UIView {

    lazy var subtractBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.hexStringToColor(hexString: "f6f6f6")
        
        btn.setTitle("—", for: .normal)
        btn.setTitleColor(UIColor.hexStringToColor(hexString: "e5e5e5"), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(UIColor.hexStringToColor(hexString: "4f4f4f"), for: .normal)
        btn.addTarget(self, action: #selector(CalculateBtn.btnClick(sender:)), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    } ()
    
    lazy var addBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.hexStringToColor(hexString: "f6f6f6")
        
        btn.setTitle("＋", for: .normal)
        btn.setTitleColor(UIColor.hexStringToColor(hexString: "e5e5e5"), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(UIColor.hexStringToColor(hexString: "4f4f4f"), for: .normal)
        btn.addTarget(self, action: #selector(CalculateBtn.btnClick(sender:)), for: .touchUpInside)
        return btn
    } ()
    
    lazy var numberText: UITextField = {
        let text = UITextField()
        text.text = "1"
        text.addTarget(self, action: #selector(CalculateBtn.textChange(sender:)), for: .valueChanged)
        text.backgroundColor = UIColor.white
        text.textAlignment = .center
        text.adjustsFontSizeToFitWidth = true
        text.keyboardType = .numberPad
        return text
    } ()
    
    func textChange(sender: UITextField) {
        checkText()
    }
    
    func btnClick(sender: UIButton) {
        var number = Int(numberText.text ?? "1") ?? 1
        
        number = number + (sender == subtractBtn ? -1 : 1)
        self.numberText.text = "\(number)"
        checkText()
    }
    
    func checkText() {
        var number = Int(numberText.text ?? "1") ?? 1
        if number < 1 {
            number = 1
        }
        subtractBtn.isEnabled = number != 1
        self.numberText.text = "\(number)"
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.addSubview(subtractBtn)
        self.addSubview(addBtn)
        self.addSubview(numberText)
        
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.hexStringToColor(hexString: "e5e5e5").cgColor
        
        subtractBtn.snp.makeConstraints({ (make) in
            make.width.equalTo(self).multipliedBy(1.0 / 3.0)
            make.height.equalTo(self)
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top)
        })
        
        addBtn.snp.makeConstraints({ (make) in
            make.width.equalTo(self).multipliedBy(1.0 / 3.0)
            make.height.equalTo(self)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
        })
        
        numberText.snp.makeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(1.0 / 3.0)
            make.center.equalTo(self)
            make.height.equalTo(self)
        }
        
        addLine()
    }

    func addLine() {
        let line1 = UIView()
        self.addSubview(line1)
        line1.backgroundColor = UIColor.hexStringToColor(hexString: "e5e5e5")
        line1.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.width.equalTo(2)
            make.left.equalTo(numberText.snp.left).offset(-1)
        }
        
        let line2 = UIView()
        self.addSubview(line2)
        line2.backgroundColor = UIColor.hexStringToColor(hexString: "e5e5e5")
        line2.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.width.equalTo(2)
            make.left.equalTo(numberText.snp.right).offset(-1)
        }
    }
    
}












