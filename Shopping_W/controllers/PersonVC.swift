//
//  PersonVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import Alamofire
import SwiftyJSON

class PersonVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexBtn: UIButton!
    
    let k_toNickNameVC = "toNickNameVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的资料"
        
        //copy 自 BaseViewController
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        
        view.backgroundColor = UIColor.hexStringToColor(hexString: "f0f0f0")
                
        let bar = UIBarButtonItem(image: UIImage(named: "返回icon"), style: .plain, target: self, action: #selector(PersonVC.ac_back))
        self.navigationItem.leftBarButtonItem = bar
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.headerImg.layer.cornerRadius = 16
        sexBtn.layer.cornerRadius = 4
        sexBtn.layer.borderColor = UIColor.hexStringToColor(hexString: "888888").cgColor
        sexBtn.layer.borderWidth = 1
        
        tableView.sectionFooterHeight = 0.1
        tableView.sectionHeaderHeight = 8
        tableView.contentInset.top = 64 - 28
        
        sexBtn.titleLabel?.textAlignment = .center
    }
    
    func ac_back() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func ac_sex(_ sender: UIButton) {
    }
    
    func alertPic() {
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                alertPic()
            case 1:
                self.performSegue(withIdentifier: k_toNickNameVC, sender: self)
                
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let vc = SafeCenterVC()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
    
    //MARK: 图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.headerImg.image = image
        
        //上传路劲 refund
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            let hud = MBProgressHUD.show(text: "上传中...", view: self.view, autoHide: false)
            hud.mode = .annularDeterminate
            let header = NetworkManager.getAllparams(params: nil) as! [String:String]
            let url = try! (NetworkManager.BASESERVER + "/uploadedFile/fileupaload?SaveFolder=refund").asURL()
//            let url = try! "http://192.168.1.14:8080/tjgy/uploadedFile/fileupaload?SaveFolder=refund".asURL()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(data, withName: "file", fileName: "img.jpg", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: header, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: { (resp) in
                        hud.hide(animated: true)
                        let j = JSON(parseJSON: resp.result.value ?? "")
                        if j["success"].boolValue {
                            let dic = j["files"][0]
                            if let p = PersonMdel.readData() {
                                p.fHeadImgUrl = dic["f_SavePath"].stringValue
                                p.update {
                                    self.headerImg.sd_setImage(with: URL.encodeUrl(string: dic["f_SavePath"].stringValue), placeholderImage: #imageLiteral(resourceName: "默认头像-方@2x"))
                                    }
                            } else {
                                MBProgressHUD.show(errorText: "上传失败")
                            }
                        }
                    })
                case .failure(let encodingError):
                    print(encodingError)
                }
            })

        }
        
        //图片控制器退出
        picker.dismiss(animated: true) {
            
        }
    }
    
    
    //MARK: 重写
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSexVC" {
            let vc = segue.destination as! SexPopoverVC
            vc.topVC = self
            vc.modalPresentationStyle = .popover
            vc.popoverPresentationController?.delegate = self
            vc.preferredContentSize = CGSize(width: 100, height: 132)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let p = PersonMdel.readData() {
            self.headerImg.sd_setImage(with: URL.encodeUrl(string: p.fHeadImgUrl), placeholderImage: #imageLiteral(resourceName: "默认头像-方@2x"))
            self.nameLabel.text = p.fNickname
            let sexStr = p.sexString().characters.count >= 2 ? p.sexString() : " " + p.sexString()
            self.sexBtn.setTitle(sexStr, for: .normal)
        }
    }
    
    //MARK: 代理
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
