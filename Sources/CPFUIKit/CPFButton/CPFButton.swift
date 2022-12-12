import UIKit

public extension CPFButton {
    /// 元素排列方式
    enum CPFElementAlignment {
        /// 元素水平排列
        case horizontal
        /// 元素垂直排列
        case vertical
    }
    // 元素优先级
    enum CPFElementPriority {
        /// 文字显示在前面/上面
        case text
        /// 图片显示在前面/上面
        case image
    }
    
    /// 按钮布局(layout of button)
    struct CPFLayout {
        /// 元素排列方式
        public var alignment: CPFElementAlignment = .horizontal
        /// 元素优先级
        public var priority: CPFElementPriority = .image
        
        // 间距, alignment方向上控件间的间距
        public var interSpace: CGFloat = 0
        // 图片显示大小范围
        public var imageSize: CGSize = .zero
        // 文字显示的最大宽度，为0表示显示全部
        public var textMaxWidth: CGFloat = 0
        // 边距
        public var margin: UIEdgeInsets = .zero
    }
}

open class CPFButton: UIButton {
    
    var layout = CPFLayout()
    private var cpfImageSize: CGSize = .zero
    private var cpfTitleSize: CGSize = .zero
    
    private func cpfImageInsets(with contentSize: CGSize) -> UIEdgeInsets {
        var insets = UIEdgeInsets.zero
        if layout.alignment == .horizontal {
            
            let extroOffset = max((contentSize.width - cpfImageSize.width - cpfTitleSize.width - layout.interSpace) / 2, 0)
            
            if layout.priority == .text {
                let offset = max(0, (contentSize.height - cpfImageSize.height) / 2)
                insets.top = offset
                insets.bottom = offset
                if cpfTitleSize.width < 1e-6 {
                    insets.left = max(floor((contentSize.width - cpfImageSize.width) / 2), 0)
                    insets.right = max(floor((contentSize.width - cpfImageSize.width) / 2), 0)
                } else {
                    insets.left = max(ceil(contentSize.width - cpfImageSize.width - extroOffset), 0)
                    insets.right = floor(extroOffset)
                }
            } else {
                let offset = max(0, (contentSize.height - cpfImageSize.height) / 2)
                insets.top = offset
                insets.bottom = offset
                if cpfTitleSize.width < 1e-6 {
                    insets.left = max(floor((contentSize.width - cpfImageSize.width) / 2), 0)
                    insets.right = max(floor((contentSize.width - cpfImageSize.width) / 2), 0)
                } else {
                    insets.right = ceil(contentSize.width - cpfImageSize.width - extroOffset)
                    insets.left = floor(extroOffset)
                }
            }
        } else {
            if layout.priority == .text {
                let offset = max(0, (contentSize.width - cpfImageSize.width) / 2)
                insets.left = offset
                insets.right = offset
                if cpfTitleSize.height < 1e-6 {
                    insets.top = max(floor((contentSize.height - cpfImageSize.height) / 2), 0)
                    insets.bottom = max(floor((contentSize.height - cpfImageSize.height) / 2), 0)
                } else {
                    insets.top = ceil(contentSize.height - cpfImageSize.height)
                }
            } else {
                let offset = max(0, (contentSize.width - cpfImageSize.width) / 2)
                insets.left = offset
                insets.right = offset
                if cpfTitleSize.height < 1e-6 {
                    insets.top = max(floor((contentSize.height - cpfImageSize.height) / 2), 0)
                    insets.bottom = max(floor((contentSize.height - cpfImageSize.height) / 2), 0)
                } else {
                    insets.bottom = ceil(contentSize.height - cpfImageSize.height)
                }
            }
        }
        return insets
    }
    private func cpfTitleInsets(with contentSize: CGSize) -> UIEdgeInsets {
        var insets = UIEdgeInsets.zero
        if layout.alignment == .horizontal {
            let extroOffset = max((contentSize.width - cpfImageSize.width - cpfTitleSize.width - layout.interSpace) / 2, 0)
            
            if layout.priority == .text {
                if cpfImageSize.width < 1e-6 {
                    insets.left = max(floor((contentSize.width - cpfTitleSize.width) / 2), 0)
                    insets.right = max(floor((contentSize.width - cpfTitleSize.width) / 2), 0)
                } else {
                    insets.right = floor(cpfImageSize.width + layout.interSpace + extroOffset)
                    insets.left = floor(extroOffset)
                }
            } else {
                if cpfImageSize.width < 1e-6 {
                    insets.left = max(floor((contentSize.width - cpfTitleSize.width) / 2), 0)
                    insets.right = max(floor((contentSize.width - cpfTitleSize.width) / 2), 0)
                } else {
                    insets.left = floor(cpfImageSize.width + layout.interSpace + extroOffset)
                    insets.right = floor(extroOffset)
                }
            }
        } else {
            
            let extroOffset = max((contentSize.width - cpfTitleSize.width) / 2, 0)
            if layout.priority == .text {
                insets.left = floor(extroOffset)
                insets.right = floor(extroOffset)
                
                if cpfImageSize.height < 1e-6 {
                    insets.top = max(floor((contentSize.height - cpfTitleSize.height) / 2), 0)
                    insets.bottom = max(floor((contentSize.height - cpfTitleSize.height) / 2), 0)
                } else {
                    insets.bottom = floor(cpfImageSize.height + layout.interSpace)
                }
            } else {
                insets.left = floor(extroOffset)
                insets.right = floor(extroOffset)
                if cpfImageSize.height < 1e-6 {
                    insets.top = max(floor((contentSize.height - cpfTitleSize.height) / 2), 0)
                    insets.bottom = max(floor((contentSize.height - cpfTitleSize.height) / 2), 0)
                } else {
                    insets.top = floor(cpfImageSize.height + layout.interSpace)
                }
            }
        }
        return insets
    }
    
    public convenience init(layout: CPFLayout) {
        self.init(frame: .zero)
        self.layout = layout
        
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    public convenience init(_ layoutConfigure: ((inout CPFLayout) -> Void)? = nil) {
        self.init(frame: .zero)
        layoutConfigure?(&layout)
        
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    func dfUpdateLayout(_ handler: (inout CPFLayout) -> Void) {
        handler(&layout)
        
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override open var intrinsicContentSize: CGSize {
        //if layout.useFixedSize { return layout.size }
        
        // 根据layout计算autolayout自动设置的大小
        var textSize: CGSize = .zero
        let limitedSize: CGSize = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
        if let attributedText = self.currentAttributedTitle, attributedText.length > 0 {
            textSize = attributedText.boundingRect(with: limitedSize, options: .usesLineFragmentOrigin, context: nil).size
        } else if let text = self.currentTitle, text.count > 0 {
            var attributes: [NSAttributedString.Key: Any] = [:]
            attributes[.font] = titleLabel?.font
            textSize = text.boundingRect(with:limitedSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        }
        
        if layout.alignment == .horizontal {
            
            var imageSize: CGSize = .zero
            if let image = currentImage, image.size != .zero {
                imageSize = layout.imageSize
                if imageSize.width < 1e-6 {
                    // 未指定imageSize时，根据button size及margin计算
                    let buttonHeight = ceil(textSize.height)
                    
                    imageSize.height = buttonHeight
                    imageSize.width = buttonHeight / image.size.height * image.size.width
                } else {
                    imageSize.width = imageSize.height / image.size.height * image.size.width
                }
            }
            
            var contentSize = textSize
            var textWidth = textSize.width
            if layout.textMaxWidth > 1e-6 {
                textWidth = min(textWidth, layout.textMaxWidth)
            }
            contentSize.width = ceil(textWidth) + ceil(imageSize.width)
            if textSize.width > 1e-6, imageSize.width > 1e-6 {
                // text、image同时存在时才使用间距
                contentSize.width += layout.interSpace
            }
            contentSize.height = max(ceil(textSize.height), ceil(imageSize.height))
            
            // margin
            contentSize.width += layout.margin.left + layout.margin.right
            contentSize.height += layout.margin.top + layout.margin.bottom
            
            cpfImageSize = imageSize
            cpfTitleSize = textSize
            return contentSize
        } else {
            var imageSize: CGSize = .zero
            if let image = currentImage, image.size != .zero {
                imageSize = layout.imageSize
                if imageSize.height < 1e-6 {
                    // 未指定imageSize时，根据button size及margin计算, image高度与文字高度相同, 无文字时指定一个高度16
                    imageSize.height = min(ceil(textSize.width), 16)
                    imageSize.width = imageSize.height / image.size.height * image.size.width
                } else {
                    // 根据高度调整宽度
                    imageSize.width = imageSize.height / image.size.height * image.size.width
                }
            }
            
            var contentSize = textSize
            var textWidth = textSize.width
            if layout.textMaxWidth > 1e-6 {
                textWidth = min(textWidth, layout.textMaxWidth)
            }
            contentSize.height = ceil(textSize.height) + ceil(imageSize.height)
            if textSize.height > 1e-6, imageSize.height > 1e-6 {
                // text、image同时存在时才使用间距
                contentSize.height += layout.interSpace
            }
            contentSize.width = max(ceil(textWidth), ceil(imageSize.width))
            
            // margin
            contentSize.width += layout.margin.left + layout.margin.right
            contentSize.height += layout.margin.top + layout.margin.bottom
            
            cpfImageSize = imageSize
            cpfTitleSize = textSize
            return contentSize
        }
    }
    
    override open func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let insets = cpfImageInsets(with: contentRect.size)
        return UIEdgeInsetsInsetRect(contentRect, insets)
    }
    
    override open func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let insets = cpfTitleInsets(with: contentRect.size)
        return UIEdgeInsetsInsetRect(contentRect, insets)
    }
    
    override open func contentRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, layout.margin)
    }
    
}
