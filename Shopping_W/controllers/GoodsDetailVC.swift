//
//  GoodsDetailVC.swift
//  Shopping_W
//
//  Created by wanwu on 2017/6/2.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import SnapKit
import WebKit

class GoodsDetailVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var scrollBk: UIScrollView!
    @IBOutlet weak var carouselView: CarouselCollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countBtn: CalculateBtn!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var typeBk: UIView!
    @IBOutlet weak var evaluateBk: UIView!
    
    @IBOutlet weak var evaluatePeopleCountLabel: UILabel!
    //标记而已
    @IBOutlet weak var typeBkFirstItem: UILabel!
    
    ///promotions
    @IBOutlet weak var promotionsBk: UIView!
    @IBOutlet weak var promotionsLabel: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    
    ///seckill
    @IBOutlet weak var seckillBk: UIView!
    @IBOutlet weak var seckilltime: UILabel!
    @IBOutlet weak var seckillNumber: UILabel!
    @IBOutlet weak var seckillLastTime: UILabel!
    
    ///group
    @IBOutlet weak var groupStartTime: UILabel!
    //团购结束时间：2017-3-30
    @IBOutlet weak var groupEndTime: UILabel!
    //总数量：10000
    @IBOutlet weak var groupNUmber: UILabel!
    //剩余时间：1231
    @IBOutlet weak var groupLaseTime: UILabel!
    @IBOutlet weak var groupBk: UIView!
    @IBOutlet weak var rightItem: UIBarButtonItem!
    
    //底部
    @IBOutlet weak var carBtn: CustomTabBarItem!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var serverbtn: CustomTabBarItem!
    @IBOutlet weak var bottomBk: UIView!
    
    //评分
    @IBOutlet weak var starView: StarMarkView!
    
    @IBOutlet weak var evaluateCountLabel: UILabel!
    
    
    var type = GoodsListVC.ListType.normal
    var currentPage = 1
    
    var detailModel = GoodsDetailModel()
    var goodsId: Int = 0
    
    lazy var webView: WKWebView = {
        let w = WKWebView(frame: CGRect.zero)
        w.uiDelegate = self
        w.navigationDelegate = self
        return w
    } ()
    
    @IBOutlet weak var typeHeight: NSLayoutConstraint!
    var itemView: GoodsTypeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //fdc249
//        setupCustomBk()
        
        starView.sadImg = #imageLiteral(resourceName: "p4.6.1.1-评价-灰.png")
        starView.likeImg = #imageLiteral(resourceName: "p4.6.1.1-评价-红.png")
        starView.margin = 5
        
        carBtn.setTitleColor(UIColor.hexStringToColor(hexString: "888888"), for: .normal)
        carBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        carBtn.badgeValue = "21"
        serverbtn.setTitleColor(UIColor.hexStringToColor(hexString: "888888"), for: .normal)
        serverbtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        countBtn.changeAction = { [unowned self] _ in
            self.updateTotalPrice()
        }
        
        requestData()
        self.typeHeight.constant = 76
        self.scrollBk.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.evaluateBk.snp.bottom).offset(8)
            make.left.right.equalTo(self.view)
            make.height.equalTo(0)
        }
    }
    
    func setupUI(model: GoodsDetailModel) {
        self.detailModel = model
        self.carouselView.reloadData()
        
        self.nameLabel.text = model.fGoodsname
        self.typeLabel.text = model.fTags
        
        starView.score = CGFloat(model.fFivestarperc) / 20.0
        starView.isTapGestureEnable = false
        starView.isPanGestureEnable = false
        
        evaluateCountLabel.text = "\(model.fFivestarperc)的用户选择了好评"
        
        self.title = model.fGoodsname
        
        switch detailModel.fPromotiontype {
        case 1:
            self.type = .group
        case 2:
            self.type = .seckill
        case 3, 4 ,5, 6:
            self.type = .promotions
        default:
            self.type = .normal
        }
        
        setupCustomBk()
        
        setupTypeView(list: model.exList)
        self.webView.loadHTMLString(model.fContentapp, baseURL: URL(string: NetworkManager.BASESERVER))
    }
    
    func requestData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        GoodsDetailModel.requestData(fGoodsid: goodsId).setSuccessAction { (bm: BaseModel<GoodsDetailModel>) in
            MBProgressHUD.hideHUD(forView: self.view)
            if let m = bm.list?.first {
                self.setupUI(model: m)
            }
        }.seterrorAction { (err) in
            MBProgressHUD.hideHUD(forView: self.view)
        }
        
        
        let params = ["method":"apievaluations", "fGoodsid":goodsId, "fStartext":"", "currentPage":currentPage, "pageSize":CustomValue.pageSize] as [String : Any]
        NetworkManager.requestPageInfoModel(params: params).setSuccessAction { (bm: BaseModel<EvaluationModel>) in
            bm.whenSuccess {
                self.evaluatePeopleCountLabel.text = "评价(\(bm.pageInfo!.total))"
            }
        }
    }
    
    func setupCustomBk() {
        var promotionsH: CGFloat = 0//45
        var seckillH: CGFloat = 0//70
        var groupH: CGFloat = 0//73
        
        if type == .normal {
            
        } else if type == .promotions {//促销
            promotionsH = 45
        } else if type == .seckill { // 秒杀
            seckillH = 70
        } else if type == .group { // 团购
            groupH = 73
        }
        
        if promotionsH == 0 {
            promotionsBk.isHidden = true
        }
        
        if seckillH == 0 {
            seckillBk.isHidden = true
        }
        
        if groupH == 0 {
            groupBk.isHidden = true
        }
        
        promotionsBk.snp.updateConstraints { (make) in
            make.height.equalTo(promotionsH)
        }
        seckillBk.snp.updateConstraints { (make) in
            make.height.equalTo(seckillH)
        }
        groupBk.snp.updateConstraints { (make) in
            make.height.equalTo(groupH)
        }
    }
    
    func setupTypeView(list: [GoodsTypeModel]?) {
        let layout = LeftAlignLayout()
        layout.minimumLineSpacing = 5
        itemView = GoodsTypeView(frame: CGRect.zero, collectionViewLayout: layout)
        
        itemView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        
        itemView.types = list ?? [GoodsTypeModel]()
        
        layout.setWidthFotItem { [unowned self] (idx) -> CGSize in
            return self.itemView.getSize(idx: idx)
        }
        layout.caculateComplete = { [unowned self] _ in
            self.typeHeight.constant = 76 + layout.maxY
        }
        
        itemView.clickAction = { [unowned self] _ in
            self.uodatePriceLabel()
        }
        
        self.uodatePriceLabel()
        typeBk.addSubview(itemView)
        itemView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(typeBk)
        }
        
        if (list?.count) ?? 0 <= 0 {
            typeBkFirstItem.isHidden = true
            return
        }
//        var currentView: UIView = typeBkFirstItem
//        for i in 0..<list!.count {
//            let goodsType = list![i]
//            let currentBtn = UIButton(type: .system)
//            
//            currentBtn.setTitle("\(i)个", for: .normal)
//            currentBtn.setTitleColor(UIColor.hexStringToColor(hexString: "fdc249"), for: .normal)
//            currentBtn.setTitleColor(CustomValue.common_red, for: .highlighted)
//            currentBtn.layer.cornerRadius = 4
//            currentBtn.layer.borderColor = UIColor.hexStringToColor(hexString: "fdc249").cgColor
//            currentBtn.layer.borderWidth = 1
//            
//            typeBk.addSubview(currentBtn)
//            
//            currentBtn.snp.makeConstraints({ (make) in
//                make.centerY.equalTo(currentView)
//                make.width.equalTo(50)
//                make.height.equalTo(25)
//                make.left.equalTo(currentView.snp.right).offset(20)
//            })
//            
//            currentView = currentBtn
//        }
    }
    var minPrice = 0.0
    var maxPrice = 0.0
    
    func uodatePriceLabel() {
        let models = self.itemView.getConformityModels()
        if models.isEmpty {
            self.promotionsLabel.text = 0.0.moneyValue()
            return
        }
        
        var min = models[0].fSalesprice
        var max = min
        var maxCount = models[0].fStock
        
        for m in models {
            min = m.fSalesprice < min ? m.fSalesprice : min
            max = m.fSalesprice > max ? m.fSalesprice : max
            maxCount = m.fStock > maxCount ? m.fStock : maxCount
        }

        if min < max {
            self.perPriceLabel.text = "\(min.moneyValue()) - \(max.moneyValue())"
        } else {
            self.perPriceLabel.text = min.moneyValue()
        }
        maxPrice = max
        minPrice = min
        updateTotalPrice()
        self.countBtn.maxCount = maxCount
    }
    
    func updateTotalPrice() {
        let count = Double(self.countBtn.numberText.text ?? "") ?? 1.0
        let min = minPrice * count
        let max = maxPrice * count
        if min < max {
            self.totalPriceLabel.text = "\(min.moneyValue()) - \(max.moneyValue())"
        } else {
            self.totalPriceLabel.text = min.moneyValue()
        }
    }
    
    //MARK: 底部点击事件
    
    @IBAction func ac_shopingCar(_ sender: CustomTabBarItem) {
        CustomTabBarVC.instance.selectToFirst(index: 2)
    }
    
    @IBAction func ac_server(_ sender: CustomTabBarItem) {
    }
    
    @IBAction func ac_add(_ sender: UIButton) {
        var fgid = 0
        let types = itemView.getConformityModels()
        if types.count > 1 {
            MBProgressHUD.show(warningText: "请先选择商品类型")
            return
        } else {
            fgid = types.isEmpty ? (self.detailModel.exList?.first?.fGeid) ?? 0 : types[0].fGeid
        }
        
        let count = Int(countBtn.numberText.text ?? "") ?? 1
        
        let params = ["method":"apiaddtoshopcart", "fGoodsid":self.goodsId, "fCount":count, "fGeid":fgid, "fPromotionid":""] as [String : Any]
        NetworkManager.requestModel(params: params, success: { (bm: BaseModel<CodeModel>) in
            bm.whenSuccess {
                MBProgressHUD.show(successText: "添加成功")
                CarVC.needsReload = true
            }
        }) { (err) in
            
        }
    }
    
    
    @IBAction func ac_right(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    //重写
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.scrollBk.contentSize.height = tableView.frame.maxY
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            if let vc = segue.destination as? CollectionPopoverVC {
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController?.delegate = self
                vc.preferredContentSize = CGSize(width: 140, height: 100)
                vc.parentVC = self
            }
        } else if segue.identifier == "toEvaluateVC" {
            let vc = segue.destination as! EvaluateVC
            vc.goodsId = self.goodsId
        }
    }

}

extension GoodsDetailVC {
    //MARK: 代理
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { (a, err) in
            if let height = a as? CGFloat {
                webView.snp.updateConstraints { (make) in
                    make.height.equalTo(height)
                }
                self.scrollBk.contentSize.height = self.evaluateBk.frame.maxY + height
            }
        }
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselView {
            return (detailModel.picList?.count) ?? 0
        }
        return FirstItem.defaultDatas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCollectionViewCell
        let dic = detailModel.picList![indexPath.row]
        cell.imageView.sd_setImage(with: URL.encodeUrl(string: dic["fUrl"] as! String), placeholderImage: #imageLiteral(resourceName: "placehoder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == carouselView {
            //MARK: 必须用 realCurrentIndexPath才是准确的
            print(carouselView.realCurrentIndexPath)
        }
    }
    
    
}
