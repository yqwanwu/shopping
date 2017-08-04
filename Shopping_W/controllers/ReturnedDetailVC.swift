//
//  ReturnedDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/7.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class ReturnedDetailVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var topBtnArr: [UIButton]!
    @IBOutlet weak var reasonText: PlacehodelTextView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    var returnedModel: ReturnedModel!
    var fImgs = ""
    
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
        if !Tools.stringIsNotBlank(text: self.reasonText.text) {
            MBProgressHUD.show(errorText: "请先填写退货理由")
            return
        }
        if self.fImgs == "" {
            MBProgressHUD.show(errorText: "请先上传照片")
            return
        }
//        method	string	apiaddrefund	无
//        fType	int	自行获取	0退货 1换货
//        fOrderid	int	自行获取	订单id
//        fOrderexid	int	自行获取	订单明细ID
//        fReason	string	自行获取	退换货理由
//        fImgs	String	自行获取	图片地址（相对），用JSON数组存储
        let tag = self.topBtnArr.filter({ $0.isSelected }).first!.tag
        let params = ["method":"apiaddrefund", "fType":tag, "fOrderid":returnedModel.fOrderid, "fOrderexid":returnedModel.fOeid, "fReason":self.reasonText.text!, "fImgs":fImgs] as [String : Any]
        
        MBProgressHUD.show()
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hideHUD()
            if bm.isSuccess {
                ReturnedVC.needReload = true
                self.view.addSubview(self.waitVC.view)
            } else {
                MBProgressHUD.show(errorText: bm.message)
            }
        }) { (err) in
            MBProgressHUD.hideHUD()
        }
    }
    
    //MARK: 代理
    //MARK: 图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.photoView.image = image
        self.photoView.contentMode = .scaleAspectFill
        
        //上传路劲 refund
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            let hud = MBProgressHUD.show(text: "上传中...", view: self.view, autoHide: false)
            hud.mode = .annularDeterminate
            let header = NetworkManager.getAllparams(params: nil) as! [String:String]
            let url = try! (NetworkManager.BASESERVER + "/uploadedFile/fileupaload?SaveFolder=refund").asURL()

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(data, withName: "file", fileName: "img.jpg", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: header, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: { (resp) in
                        hud.hide(animated: true)
                        let j = JSON(parseJSON: resp.result.value ?? "")
                        if j["success"].boolValue {
                            self.fImgs = j["files"].rawString() ?? ""
                            let dic = j["files"][0]
                             self.photoView.sd_setImage(with: URL.encodeUrl(string: dic["f_SavePath"].stringValue), placeholderImage: #imageLiteral(resourceName: "placehoder"))
                            self.photoView.contentMode = .scaleAspectFit
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
}
