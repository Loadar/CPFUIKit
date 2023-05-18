//
//  File.swift
//  
//
//  Created by Aaron on 2023/4/4.
//

import UIKit

public extension PaddingLabel {
    /// 布局
    struct Layout {
        /// 内边距，默认zero
        public var contentInsets: UIEdgeInsets = .zero
        /// 尺寸为0时是否忽略内边距，默认true
        public var ignoreContentInsetsWhenZeroSize = true
        
        public static var `default`: Self { .init() }
    }
}
