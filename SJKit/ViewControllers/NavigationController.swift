//
//  NavigationController.swift
//  SJKit
//
//  Created by shijia.chen on 2021/10/14.
//  Copyright © 2021 Watermelon. All rights reserved.
//

import UIKit

open class NavigationController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        // Do any additional setup after loading the view.
        
        print("wo featureB")
    }
    
    func featureB() {
        print("suibian")
    }
}

extension NavigationController: UINavigationControllerDelegate {
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
