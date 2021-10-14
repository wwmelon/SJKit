//
//  BaseWebViewController.swift
//  SJKit
//
//  Created by shijia.chen on 2021/10/13.
//  Copyright © 2021 Watermelon. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController {

    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: config)
        view.uiDelegate = self
        view.navigationDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
    }
}

extension BaseWebViewController: WKUIDelegate, WKNavigationDelegate {
    
}
