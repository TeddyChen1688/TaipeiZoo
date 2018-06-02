//
//  UINavigationController+Ext.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/28.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
}
