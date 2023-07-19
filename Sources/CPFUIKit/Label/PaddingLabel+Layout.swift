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
        /// 总尺寸，包含内容及边距
        /// - 控件总尺寸建议优先使用外部布局约束，某些特殊情况下可以指定此值
        /// - 指定的尺寸宽、高分别判定，正值有效
        public var size: CGSize = .zero

        public static var `default`: Self { .init() }
    }
}
