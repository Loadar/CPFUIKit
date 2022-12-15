//
//  Util.swift
//  
//
//  Created by Aaron on 2022/12/14.
//

import UIKit

public struct Util {
    
}

extension Util {
    /// 最顶层的ViewController
    /// 如果没有modal方式展示的，返回的就是window的rootViewController；否则返回最顶层modal展示的view controller
    /// - Parameter findChild: 是否寻找子视图控制器，若指定的话，且最上层的视图控制器是UITabBarController、UINavigationController或其子类，则尝试获取其最上层的子视图控制器
    public static func topController(findChild: Bool = false) -> UIViewController? {
        var controller = UIApplication.shared.keyWindow?.rootViewController
        while let aController = controller?.presentedViewController {
            controller = aController
        }
        
        if let tabBarController = controller as? UITabBarController, let viewControllers = tabBarController.viewControllers {
            if (0..<viewControllers.count).contains(tabBarController.selectedIndex) {
                controller = viewControllers[tabBarController.selectedIndex]
            }
        }
        if let navigationController = controller as? UINavigationController, let topController = navigationController.topViewController {
            controller = topController
        }

        return controller
    }
}
