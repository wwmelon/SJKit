//
//  BaseViewController.swift
//  SJKit
//
//  Created by shijia.chen on 2021/10/12.
//  Copyright © 2021 Watermelon. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {

    private lazy var backButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: A.collapsed_icon.image, style: .plain, target: self, action: #selector(onBack(_:)))
    }()
    
    private lazy var closeButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: A.collapsed_icon.image, style: .plain, target: self, action: #selector(onClose(_:)))
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupNavigationBar()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func onBack(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func onClose(_ sender: UIBarButtonItem) {
        
    }
    
    deinit {
        print("[Free VC]: \(self)")
    }
}

extension BaseViewController {
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
}
