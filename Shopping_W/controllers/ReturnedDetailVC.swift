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

class ReturnedDetailVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var topBtnArr: [UIButton]!
    @IBOutlet weak var reasonText: PlacehodelTextView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var selectedAsset = [Any]()
    
    var selectedPhotos = [UIImage]()
    
    var returnedModel: ReturnedModel!
    
    let waitVC: WaitVC = {
        let w = Tools.getClassFromStorybord(sbName: .mine, clazz: WaitVC.self) as! WaitVC
        return w
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        reasonText.placehoderLabel?.text = "请填写退换货理由"
        reasonText.layer.cornerRadius = CustomValue.btnCornerRadius
//        photoView.layer.cornerRadius = CustomValue.btnCornerRadius
        uploadBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        topBtnArr.first?.isSelected = true
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        self.addChildViewController(waitVC)
        
        collectionView.register(TZTestCell.self, forCellWithReuseIdentifier: "TZTestCell")
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
    
//    @IBAction func ac_uploadPhoto(_ sender: UIButton) {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            //初始化图片控制器
//            let picker = UIImagePickerController()
//            //设置代理
//            picker.delegate = self
//            //指定图片控制器类型
//            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//            //设置是否允许编辑
//            picker.allowsEditing = true
//            //弹出控制器，显示界面
//            self.present(picker, animated: true, completion: {
//                () -> Void in
//            })
//        } else {
//            let alert = UIAlertController(title: "提示", message: "请在设置中打开访问相册的权限", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "确定", style:.default, handler: { (ac) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: {
//
//            })
//        }
//    }

    @IBAction func ac_submit(_ sender: UIButton) {
        if !Tools.stringIsNotBlank(text: self.reasonText.text) {
            MBProgressHUD.show(errorText: "请先填写退货理由")
            return
        }
        if self.selectedPhotos.isEmpty {
            MBProgressHUD.show(errorText: "请先上传照片")
            return
        }

        count = 0
        fimgs.removeAll()
        if !selectedPhotos.isEmpty {
            uploadPic(image: selectedPhotos[count])
        }
    }
    
    func requestData() {
        let tag = self.topBtnArr.filter({ $0.isSelected }).first!.tag
        let params = ["method":"apiaddrefund", "fType":tag, "fOrderid":returnedModel.fOrderid, "fOrderexid":returnedModel.fOeid, "fReason":self.reasonText.text!, "fImgs":fimgs] as [String : Any]
        
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
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        //获取选择的原图
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
//
//        self.photoView.image = image
//        self.photoView.contentMode = .scaleAspectFill
//
//        //上传路劲 refund
//        if let data = UIImageJPEGRepresentation(image, 0.1) {
//            let hud = MBProgressHUD.show(text: "上传中...", view: self.view, autoHide: false)
//            hud.mode = .annularDeterminate
//            let header = NetworkManager.getAllparams(params: nil) as! [String:String]
//            let url = try! (NetworkManager.BASESERVER + "/uploadedFile/fileupaload?SaveFolder=evaluation").asURL()
//
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                multipartFormData.append(data, withName: "file", fileName: "img.jpg", mimeType: "image/jpeg")
//            }, to: url, method: .post, headers: header, encodingCompletion: { (encodingResult) in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseString(completionHandler: { (resp) in
//                        hud.hide(animated: true)
//                        let j = JSON(parseJSON: resp.result.value ?? "")
//                        if j["success"].boolValue {
//                            self.fImgs = j["files"].rawString() ?? ""
//                            let dic = j["files"][0]
//                             self.photoView.sd_setImage(with: URL.encodeUrl(string: dic["f_SavePath"].stringValue), placeholderImage: #imageLiteral(resourceName: "placehoder"))
//                            self.photoView.contentMode = .scaleAspectFit
//                        }
//                    })
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//            })
//
//        }
//
//        //图片控制器退出
//        picker.dismiss(animated: true) {
//
//        }
//    }
    
    
    
    ////上面的代码不要了
    func deleteBtnClik(sender: UIButton) {
        selectedPhotos.remove(at: sender.tag)
        selectedAsset.remove(at: sender.tag)
        collectionView.performBatchUpdates({
            let index = IndexPath(row: sender.tag, section: 0)
            self.collectionView.deleteItems(at: [index])
            
        }) { (f) in
            self.collectionView.reloadData()
        }
    }
    
    var count = 0
    var fimgs = [String]()
    func uploadPic(image: UIImage) {
        //上传路劲 refund
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            let hud = MBProgressHUD.show(text: "图片上传中...", view: self.view, autoHide: false)
            hud.mode = .annularDeterminate
            let header = NetworkManager.getAllparams(params: nil) as! [String:String]
            let url = try! (NetworkManager.BASESERVER + "/uploadedFile/fileupaload?SaveFolder=evaluation").asURL()
            
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
                            self.fimgs.append(dic["f_SavePath"].stringValue)
                            self.count += 1
                            
                            if self.count >= self.selectedPhotos.count {//上传完成
                                self.requestData()
                            } else {
                                self.uploadPic(image: self.selectedPhotos[self.count])
                            }
                            
                        } else {
                            self.count = 0
                            MBProgressHUD.show(errorText: "上传失败")
                        }
                    })
                case .failure(let encodingError):
                    self.count = 0
                    MBProgressHUD.show(errorText: "上传失败")
                }
            })
            
        }
    }
    
    
    
    //代理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TZTestCell", for: indexPath) as! TZTestCell
        cell.videoImageView.isHidden = true
        
        if indexPath.row == selectedPhotos.count {
            cell.imageView.image = UIImage(named: "AlbumAddBtn.png")
            cell.deleteBtn.isHidden = true
            
        } else {
            cell.imageView.image = selectedPhotos[indexPath.row]
            //            cell.asset = selectedPhotos[indexPath.row]
            cell.deleteBtn.isHidden = false
        }
        cell.gifLable.isHidden = true
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClik(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == selectedPhotos.count {
            let imagePickerVc = TZImagePickerController(maxImagesCount: 5 - selectedPhotos.count, delegate: self)!
            imagePickerVc.allowPickingGif = false
            imagePickerVc.allowPickingVideo = false
            self.present(imagePickerVc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        selectedPhotos.append(contentsOf: photos)
        selectedAsset.append(contentsOf: assets)
        collectionView.reloadData()
    }
}
