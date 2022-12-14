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
    public static var topController: UIViewController? {
        var controller = UIApplication.shared.keyWindow?.rootViewController
        while let aController = controller?.presentedViewController {
            controller = aController
        }
        return controller
    }
}
