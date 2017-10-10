//
//  MyEvaluateVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/6.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

///商品评价，不是列表，名字整错了
class MyEvaluateVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var starView: StarMarkView!
    @IBOutlet weak var textView: PlacehodelTextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var imagePickerVc: TZImagePickerController = {
        let vc = TZImagePickerController(maxImagesCount: 2, delegate: self)!
        vc.allowPickingGif = false
        vc.allowPickingVideo = false
        return vc
    } ()
    var selectedAsset = [Any]()
    
    var selectedPhotos = [UIImage]()
    
    var orderModel: OrderModel!
    var canEdit = true
    var evaluateItem: MyEvaluationModelItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        starView.sadImg = #imageLiteral(resourceName: "p4.6.1.1-评价-灰.png")
        starView.likeImg = #imageLiteral(resourceName: "p4.6.1.1-评价-红.png")
        starView.margin = 8
        starView.isFullStar = true
        textView.layer.cornerRadius = CustomValue.btnCornerRadius
        textView.placeholderText = "请输入评价内容"
        textView.placehoderLabel?.text = "请输入评价内容"
        submitBtn.layer.cornerRadius = CustomValue.btnCornerRadius
        
        view.backgroundColor = UIColor.white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TZTestCell.self, forCellWithReuseIdentifier: "TZTestCell")
        
        if !canEdit {
            for v in view.subviews {
                v.isUserInteractionEnabled = false
                submitBtn.isHidden = true
            }
        }
        
        if let m = evaluateItem {
            self.starView.score = CGFloat(m.fStar)
            self.textView.text = m.fContent
            self.textView.placehoderLabel?.isHidden = true
        }
    }

    @IBAction func ac_submit(_ sender: Any) {
        count = 0
        fimgs.removeAll()
        if !selectedPhotos.isEmpty {
            uploadPic(image: selectedPhotos[count])
        }
        
    }
    
    func requestData() {
        let score = Int(starView.score)
        var params = ["method":"apieditevaluation", "fStar":score, "fContent":textView.text ?? "", "fPiclist": fimgs] as [String : Any]
        if let m = evaluateItem {
            params["fEvaluationid"] = m.fEvaluationid
            params["fGoodsid"] = m.fGoodsid
            params["fOrderid"] = m.fOrderid
        } else {
            params["fGoodsid"] = orderModel.orderEx[0].fGoodsid
            params["fOrderid"] = orderModel.fOrderid
        }
        MBProgressHUD.show()
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            MBProgressHUD.hideHUD()
            bm.whenSuccess {
                self.navigationController?.popViewController(animated: true)
                OrderVC.needUpdate = true
            }
        }) { (err) in
            MBProgressHUD.hideHUD()
            MBProgressHUD.show(errorText: "请求失败")
        }
    }
    
    func deleteBtnClik(sender: UIButton) {
        selectedPhotos.remove(at: sender.tag)
        selectedAsset.remove(at: sender.tag)
        collectionView.performBatchUpdates({
            let index = IndexPath(row: sender.tag, section: 0)
            self.collectionView.deleteItems(at: [index])
            
        }) { (f) in
            self.imagePickerVc.selectedAssets = NSMutableArray(array: self.selectedAsset)
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
            self.present(self.imagePickerVc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        selectedPhotos = photos
        selectedAsset = assets
        collectionView.reloadData()
    }
}


