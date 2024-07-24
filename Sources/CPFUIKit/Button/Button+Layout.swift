//
//  Button+Layout.swift
//  
//
//  Created by Aaron on 2023/3/28.
//

import UIKit

public extension Button {
    /// 按钮布局
    struct Layout {
        /// 元素排列轴
        public enum Axis {
            /// 水平
            case horizontal
            /// 垂直
            case vertical
        }
        
        /// 元素优先级
        public enum Priority {
            /// 文字显示在前面/上面
            case text
            /// 图片显示在前面/上面
            case image
        }
        
        /// 内容排列方式
        public enum ContentAlignment {
            /// 起始对齐
            case leading
            /// 居中
            case center
            /// 结尾对齐
            case trailing
        }
        
        /// 元素排列轴，默认水平轴
        public var axis: Axis = .horizontal
        /// 元素优先级，默认图标优先
        public var priority: Priority = .image
        /// 元素间距，默认0
        public var interSpace: CGFloat = 0
        
        /// 图片尺寸
        /// - 此处指的是**imageView**的尺寸，图片具体显示尺寸同时受**imageView**的**contentMode**影响
        /// - 若指定的图片尺寸无效(**非正值**)时，将使用图片本身的尺寸
        public var imageSize: CGSize = .zero
        /// 文字显示的最大宽度，正值有效，非正值表示显示全部
        public var maxTextWidth: CGFloat = 0
        /// 文字尺寸，规则同 imageSize
        public var textSize: CGSize = .zero
        
        /// 总尺寸，包含内容及边距
        /// - 控件总尺寸建议优先使用外部布局约束，某些特殊情况下可以指定此值
        /// - 指定的尺寸宽、高分别判定，正值有效
        public var size: CGSize = .zero
        /// 最小总尺寸，规则同totalSize
        public var minSize: CGSize = .zero
        /// 最大总尺寸，规则同totalSize
        public var maxSize: CGSize = .zero

        /// 内容边距，默认zero
        public var contentInsets: UIEdgeInsets = .zero
        /// 水平方向内容排列方式，默认center
        public var horizontalContentAlignment: ContentAlignment = .center
        /// 垂直方向内容排列方式，默认center
        public var verticalContentAlignment: ContentAlignment = .center

        /// 高亮状态下无法匹配字体时，优先取其当前非高亮状态的字体，默认true
        /// - 为true时，如按钮状态从**.selected**变成**[.selected, .highlighted]**，若匹配不到字体，优先取**.selected**状态的字体
        /// - 为false时，当前状态匹配不到字体时，总是尝试取**.normal**状态的字体，若未指定，取当前字体信息中的第一个，若仍无，使用默认字体
        public var useFontOfUnHighlightedState = true
        
        public static var `default`: Self { .init() }
    }
}
