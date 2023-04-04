//
//  Feature.swift
//  Demo
//
//  Created by Aaron on 2023/3/30.
//

import Foundation

/// 特性
enum Feature {
    /// 按钮
    case button
    
    
    var title: String {
        switch self {
        case .button: return "按钮"
        }
    }
}
