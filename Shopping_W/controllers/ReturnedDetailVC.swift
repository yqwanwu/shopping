//
//  ReturnedDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class ReturnedDetailVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var topBtnArr: [UIButton]!
    @IBOutlet weak var reasonText: PlacehodelTextView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    let waitVC: WaitVC = {
        let w = Tools.getClassFromStorybord(sbName: .mine, clazz: WaitVC.self) as! WaitVC
        return w
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        reasonText.placehoderLabel?.text = "请填写退换货理由"
        reasonText.layer.cornerRadius = CustomValue.btnCornerRadius
        photoView.layer.cornerRadius = CustomValue.btnCornerRadius
        uploadBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        topBtnArr.first?.isSelected = true
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        self.addChildViewController(waitVC)
    }
    
    
    @IBAction func ac_return(_ sender: UIButton) {
        for btn in topBtnArr {
            btn.isSelected = false
        }
        sender.isSelected = true
    }
    
    @IBAction func ac_change(_ sender: UIButton) {
        for btn in topBtnArr {
            btn.isSelected = false
        }
        sender.isSelected = true
    }
    
    @IBAction func ac_uploadPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = true
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        } else {
            let alert = UIAlertController(title: "提示", message: "请在设置中打开访问相册的权限", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style:.default, handler: { (ac) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: {
                
            })
        }
    }

    @IBAction func ac_submit(_ sender: UIButton) {
        self.view.addSubview(waitVC.view)
    }
    
    //MARK: 代理
    //MARK: 图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.photoView.image = image
        self.photoView.contentMode = .scaleAspectFill
        
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            let hud = MBProgressHUD.show(text: "上传中...", view: self.view, autoHide: false)
            hud.mode = .annularDeterminate
        }
        
        //图片控制器退出
        picker.dismiss(animated: true) {
            
        }
    }
}
