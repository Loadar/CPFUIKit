//
//  Button+CPFAttributes.swift
//  
//
//  Created by Aaron on 2023/3/29.
//

import UIKit

extension Button {
    /// 按钮属性
    struct CPFAttributes {
        /// 图像尺寸
        private(set) var imageSize: CGSize = .zero
        /// 文字尺寸
        private(set) var textSize: CGSize = .zero
        
        /// 计算图像布局
        func imageInsets(in contentSize: CGSize, of button: Button) -> UIEdgeInsets {
            let layout = button.layout
            var insets = UIEdgeInsets.zero
            
            switch layout.axis {
            case .horizontal:
                // 元素内容宽度
                let elementContentWidth: CGFloat = {
                    var width = imageSize.width
                    // 无文字时忽略间距
                    if textSize.width > 0 {
                        width += textSize.width + layout.interSpace
                    }
                    return width
                }()
                
                // 去除元素后的内容宽度
                let contentWidthWithoutElements = contentSize.width - elementContentWidth
                // 实际展示的元素内容宽度(超长截断)
                let finalElementCotentWidth = {
                    if contentWidthWithoutElements >= 0 {
                        return elementContentWidth
                    } else {
                        return elementContentWidth + contentWidthWithoutElements
                    }
                }()
                switch layout.horizontalContentAlignment {
                case .leading:
                    insets.right = max(contentWidthWithoutElements, 0)
                case .center:
                    let offset = max(contentWidthWithoutElements / 2, 0)
                    insets.left = offset
                    insets.right = offset
                case .trailing:
                    insets.left = max(contentWidthWithoutElements, 0)
                }
                
                // 去除图像后的内容高度
                let contentHeightWithoutImage = contentSize.height - imageSize.height
                switch layout.verticalContentAlignment {
                case .leading:
                    insets.bottom = max(contentHeightWithoutImage, 0)
                case .center:
                    let offset = max(contentHeightWithoutImage / 2, 0)
                    insets.top = offset
                    insets.bottom = offset
                case .trailing:
                    insets.top = max(contentHeightWithoutImage, 0)
                }
                
                switch layout.priority {
                case .text:
                    if textSize.width > 0 {
                        insets.left += finalElementCotentWidth - imageSize.width
                    }
                case .image:
                    if textSize.width > 0 {
                        insets.right += finalElementCotentWidth - imageSize.width
                    }
                }
            case .vertical:
                // 元素内容高度
                let elementContentHeight: CGFloat = {
                    var height = imageSize.height
                    // 无文字时忽略间距
                    if textSize.height > 0 {
                        height += textSize.height + layout.interSpace
                    }
                    return height
                }()
                
                // 去除元素后的内容高度
                let contentHeightWithoutElements = contentSize.height - elementContentHeight
                switch layout.verticalContentAlignment {
                case .leading:
                    insets.bottom = max(contentHeightWithoutElements, 0)
                case .center:
                    let offset = max(contentHeightWithoutElements / 2, 0)
                    insets.top = offset
                    insets.bottom = offset
                case .trailing:
                    insets.top = max(contentHeightWithoutElements, 0)
                }
                
                // 去除图像后的内容宽度
                let contentWidthWithoutImage = contentSize.width - imageSize.width
                switch layout.horizontalContentAlignment {
                case .leading:
                    insets.right = max(contentWidthWithoutImage, 0)
                case .center:
                    let offset = max(contentWidthWithoutImage / 2, 0)
                    insets.left = offset
                    insets.right = offset
                case .trailing:
                    insets.left = max(contentWidthWithoutImage, 0)
                }
                
                switch layout.priority {
                case .text:
                    if textSize.width > 0 {
                        insets.top += elementContentHeight - imageSize.height
                    }
                case .image:
                    if textSize.width > 0 {
                        insets.bottom += elementContentHeight - imageSize.height
                    }
                }
            }
            return insets
        }
        
        /// 计算文字布局
        func textInsets(in contentSize: CGSize, of button: Button) -> UIEdgeInsets {
            let layout = button.layout
            var insets = UIEdgeInsets.zero
            
            switch layout.axis {
            case .horizontal:
                // 元素内容宽度
                let elementContentWidth: CGFloat = {
                    var width = textSize.width
                    // 无图像时忽略间距
                    if imageSize.width > 0 {
                        width += imageSize.width + layout.interSpace
                    }
                    return width
                }()
                
                // 去除元素后的内容宽度
                let contentWidthWithoutElements = contentSize.width - elementContentWidth
                switch layout.horizontalContentAlignment {
                case .leading:
                    insets.right = max(contentWidthWithoutElements, 0)
                case .center:
                    let offset = max(contentWidthWithoutElements / 2, 0)
                    insets.left = offset
                    insets.right = offset
                case .trailing:
                    insets.left = max(contentWidthWithoutElements, 0)
                }
                
                // 去除文字后的内容高度
                let contentHeightWithoutText = contentSize.height - textSize.height
                switch layout.verticalContentAlignment {
                case .leading:
                    insets.bottom = max(contentHeightWithoutText, 0)
                case .center:
                    let offset = max(contentHeightWithoutText / 2, 0)
                    insets.top = offset
                    insets.bottom = offset
                case .trailing:
                    insets.top = max(contentHeightWithoutText, 0)
                }
                
                switch layout.priority {
                case .text:
                    if imageSize.width > 0 {
                        insets.right += imageSize.width + layout.interSpace
                    }
                case .image:
                    if imageSize.width > 0 {
                        insets.left += imageSize.width + layout.interSpace
                    }
                }
            case .vertical:
                // 元素内容高度
                let elementContentHeight: CGFloat = {
                    var height = textSize.height
                    // 无图像时忽略间距
                    if imageSize.height > 0 {
                        height += imageSize.height + layout.interSpace
                    }
                    return height
                }()
                
                // 去除元素后的内容高度
                let contentHeightWithoutElements = contentSize.height - elementContentHeight
                switch layout.verticalContentAlignment {
                case .leading:
                    insets.bottom = max(contentHeightWithoutElements, 0)
                case .center:
                    let offset = max(contentHeightWithoutElements / 2, 0)
                    insets.top = offset
                    insets.bottom = offset
                case .trailing:
                    insets.top = max(contentHeightWithoutElements, 0)
                }
                
                // 去除文字后的内容宽度
                let contentWidthWithoutText = contentSize.width - textSize.width
                switch layout.horizontalContentAlignment {
                case .leading:
                    insets.right = max(contentWidthWithoutText, 0)
                case .center:
                    let offset = max(contentWidthWithoutText / 2, 0)
                    insets.left = offset
                    insets.right = offset
                case .trailing:
                    insets.left = max(contentWidthWithoutText, 0)
                }
                
                switch layout.priority {
                case .text:
                    if imageSize.width > 0 {
                        insets.bottom += imageSize.height + layout.interSpace
                    }
                case .image:
                    if imageSize.width > 0 {
                        insets.top += imageSize.height + layout.interSpace
                    }
                }
            }
            
            return insets
        }
        
        /// 计算按钮尺寸，也会同时计算出图像、文字尺寸
        /// - Parameters:
        ///   - title: 展示的标题
        ///   - attributedTitle: 展示的属性标题，优先级高于title
        ///   - image: 展示的图像
        ///   - button: 按钮
        ///   - state: 按钮状态，可能和按钮当前状态不同
        /// - Returns: 按钮总尺寸，包括内边距
        mutating func buttonSize(
            of title: String?,
            attributedTitle: NSAttributedString?,
            image: UIImage?,
            button: Button,
            state: UIControl.State
        ) -> CGSize {
            
            var textSize: CGSize = .zero
            var imageSize: CGSize = .zero
            var contentSize: CGSize = .zero
            var totalSize: CGSize = .zero
            defer {
                if state == button.state {
                    self.textSize = textSize
                    self.imageSize = imageSize
                }
            }
            
            let layout = button.layout
            
            // 文字
            let limitedSize: CGSize = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
            if let attributedText = attributedTitle, attributedText.length > 0 {
                textSize = attributedText.boundingRect(with: limitedSize, options: .usesLineFragmentOrigin, context: nil).size
            } else if let text = title, !text.isEmpty {
                var attributes: [NSAttributedString.Key: Any] = [:]
                attributes[.font] = button.font(for: state) ?? button.titleLabel?.font
                textSize = text.boundingRect(with:limitedSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
            }
            if textSize != .zero {
                if layout.textSize.width > 0 {
                    textSize.width = layout.textSize.width
                }
                if layout.textSize.height > 0 {
                    textSize.height = layout.textSize.height
                }
            }

            // 图像
            if let image = image, image.size != .zero {
                // 可展示的图像
                imageSize = image.size
                if layout.imageSize.width > 0 {
                    imageSize.width = layout.imageSize.width
                }
                if layout.imageSize.height > 0 {
                    imageSize.height = layout.imageSize.height
                }
            }
            
            if layout.size.width > 0 {
                totalSize.width = layout.size.width
            }
            if layout.size.height > 0 {
                totalSize.height = layout.size.height
            }

            switch layout.axis {
            case .horizontal:
                if layout.size.width <= 0 {
                    if textSize.width > 0 {
                        if layout.maxTextWidth > 0 {
                            contentSize.width += ceil(min(textSize.width, layout.maxTextWidth))
                        } else {
                            contentSize.width += ceil(textSize.width)
                        }
                    }
                    if imageSize.width > 0 {
                        if contentSize.width > 0 {
                            // text、image同时存在时才使用间距
                            contentSize.width += layout.interSpace
                        }
                        contentSize.width += ceil(imageSize.width)
                    }
                    totalSize.width = contentSize.width + layout.contentInsets.left + layout.contentInsets.right
                }
                if layout.size.height <= 0 {
                    if textSize.height > 0 {
                        contentSize.height = ceil(textSize.height)
                    }
                    
                    if imageSize.height > 0 {
                        contentSize.height = max(contentSize.height, ceil(imageSize.height))
                    }
                    totalSize.height = contentSize.height + layout.contentInsets.top + layout.contentInsets.bottom
                }
            case .vertical:
                if layout.size.width <= 0 {
                    if textSize.width > 0 {
                        if layout.maxTextWidth > 0 {
                            contentSize.width = ceil(min(textSize.width, layout.maxTextWidth))
                        } else {
                            contentSize.width = ceil(textSize.width)
                        }
                    }
                    if imageSize.width > 0 {
                        contentSize.width = max(contentSize.width, ceil(imageSize.width))
                    }
                    totalSize.width = contentSize.width + layout.contentInsets.left + layout.contentInsets.right
                }
                if layout.size.height <= 0 {
                    if textSize.height > 0 {
                        contentSize.height += ceil(textSize.height)
                    }
                    
                    if imageSize.height > 0 {
                        if contentSize.height > 0 {
                            // text、image同时存在时才使用间距
                            contentSize.height += layout.interSpace
                        }
                        contentSize.height += ceil(imageSize.height)
                    }
                    totalSize.height = contentSize.height + layout.contentInsets.top + layout.contentInsets.bottom
                }
            }
            
            if layout.minSize.width > 0 {
                totalSize.width = max(totalSize.width, layout.minSize.width)
            }
            if layout.maxSize.width > 0 {
                totalSize.width = min(totalSize.width, layout.maxSize.width)
            }
            
            if layout.minSize.height > 0 {
                totalSize.height = max(totalSize.height, layout.minSize.height)
            }
            if layout.maxSize.height > 0 {
                totalSize.height = max(totalSize.height, layout.maxSize.height)
            }
            
            return totalSize
        }
    }
}
