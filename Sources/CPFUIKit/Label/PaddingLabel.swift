//
//  PaddingLabel.swift
//  
//
//  Created by Aaron on 2023/4/4.
//

import UIKit

/// 带内边距的Label
open class PaddingLabel: UILabel {
    /// 布局
    private(set) var layout = Layout()
    
    // MARK: - Init
    public init(layout: Layout) {
        super.init(frame: .zero)
        self.layout = layout
    }
    
    public init(_ layoutUpdater: ((inout Layout) -> Void)? = nil) {
        super.init(frame: .zero)
        layoutUpdater?(&layout)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func update(layout changing: (inout Layout) -> Void) {
        changing(&layout)
        
        invalidateIntrinsicContentSize()
        setNeedsDisplay()
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: layout.contentInsets))
    }
    
    open override var intrinsicContentSize: CGSize {
        var size: CGSize = super.intrinsicContentSize
        
        let insets = layout.contentInsets
        if layout.ignoreContentInsetsWhenZeroSize {
            if size.width > 0 {
                size.width += insets.left + insets.right
            }
            if size.height > 0 {
                size.height += insets.top +  insets.bottom
            }
        } else {
            size.width += insets.left + insets.right
            size.height += insets.top +  insets.bottom
        }
        
        if layout.size.width > 0 {
            size.width = layout.size.width
        }
        if layout.size.height > 0 {
            size.height = layout.size.height
        }
        
        return size
    }
}
