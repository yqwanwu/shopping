//
//  AddressSelectVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/12.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit

class AddressSelectVC: UIViewController {
    @IBOutlet weak var picker: LinkedPicker!
    weak var topVC: FirstViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ac_cancle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ac_ok(_ sender: Any) {
        let arr = picker.getAddressArr()
        topVC?.addressBtn.setTitle(arr.last, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        picker.itemsArr.remove(at: 2)
        picker.reloadAllComponents()
    }

}
