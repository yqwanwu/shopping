//
//  PwdQuestionTableViewCell.swift
//  Shopping_W
//
//  Created by wanwu on 2017/5/25.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class PwdQuestionTableViewCell: CustomTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var lineView: UIView!
    
    override var model: CustomTableViewCellItem? {
        didSet {
            if let m = model as? PwdQuestion {
                titleText.text = m.text
                answerText.isHidden = m.detailText == nil
                lineView.isHidden = m.detailText == nil
                titleText.textColor = m.detailText == nil ? UIColor.black : UIColor.gray
                self.answerText.text = m.answer
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerText.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let m = model as? PwdQuestion {
            m.answer = textField.text ?? ""
        }
    }
    
}
