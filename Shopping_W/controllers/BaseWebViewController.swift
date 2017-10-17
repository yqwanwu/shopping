//
//  BaseWebViewController.swift
//  Shopping_W
//
//  Created by wanwu on 2017/7/17.
//  Copyright © 2017年 wanwu. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class BaseWebViewController: BaseViewController, WKNavigationDelegate, WKUIDelegate {

    var webView = WKWebView()
    
    var url: String = ""
    private var progressView = UIProgressView()
    var htmlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = self.view.bounds
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.view.addSubview(webView)
        
        webView.frame.origin.y = (self.navigationController?.navigationBar.frame.height)! + 20
        
        self.url = self.url.hasPrefix("http") ? self.url : NetworkManager.BASESERVER + "/" + self.url
        let url = URL(string: self.url)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        if let str = htmlStr {
            webView.loadHTMLString(str, baseURL: nil)
        }
        
        /**
         增加的属性：
         1.webView.estimatedProgress加载进度
         2.backForwardList 表示historyList
         3.WKWebViewConfiguration *configuration; 初始化webview的配置
         */
        self.view.addSubview(webView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        progressView = UIProgressView(frame: CGRect(x: 0, y: 44-2, width: UIScreen.main.bounds.size.width, height: 2))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor.orange
        self.navigationController?.navigationBar.addSubview(progressView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func ac_back() {
        if webView.canGoBack {
            webView.goBack()
        } else{
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            }
        }

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        self.navigationItem.title = webView.title
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
    }
    
}
