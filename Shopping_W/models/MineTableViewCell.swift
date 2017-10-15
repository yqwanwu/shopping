//
//  MineTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/26.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class MineTableViewCell: CustomTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.hexStringToColor(hexString: "f4f4f4")
    }

    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model {
                let row = 3
                let datas = m.customValue?["datas"] as! [CustomTableViewCellItem]
                let column = (datas.count + row - 1) / row
                let height = (m.heightForRow - CGFloat(column) + 1) / CGFloat(column)
                
                let width = (UIScreen.main.bounds.width - CGFloat(row) + 1) / CGFloat(row)
                
                for i in 0..<datas.count {
                    let x = CGFloat(i % row) * (width + 1)
                    let y = CGFloat(i / row) * (height + 1)
                    
                    let btn = UIButton(type: .system)
                    btn.frame = CGRect(x: x, y: y, width: width, height: height)
                    addSubview(btn)
                    btn.backgroundColor = UIColor.white
                    
                    let img = UIImageView(image: UIImage(named: datas[i].imageUrl ?? ""))
                    img.frame = CGRect(x: width / 2 - 12, y: 15, width: 24, height: 24)
                    img.contentMode = .scaleAspectFit
                    btn.addSubview(img)
                    
                    let label = UILabel(frame: CGRect(x: 0, y: img.frame.maxY + 8, width: width, height: 20))
                    label.text = datas[i].detailText
                    label.font = UIFont.systemFont(ofSize: 15)
                    label.textAlignment = .center
                    btn.addSubview(label)
                    
                    btn.addTarget(self, action: #selector(MineTableViewCell.ac_click(sender:)), for: .touchUpInside)
                    btn.tag = 1024 + i
                }
            }
        }
    }
    
    func ac_click(sender: UIButton) {
        if let datas = model?.customValue?["datas"] as? [CustomTableViewCellItem] {
            datas[sender.tag - 1024].cellAction(IndexPath(row: sender.tag - 1024, section: 0))
        }
        
    }
    

}
