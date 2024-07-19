import UIKit

/// 自定义按钮
open class Button: UIButton {
    
    /// 布局
    private(set) var layout = Layout()
    
    /// 字体信息
    private var fontInfo: [UInt: UIFont] = [:]
    /// 属性
    private var cpfAttributes = CPFAttributes()
    
    // MARK: - Init
    public init(layout: Layout) {
        super.init(frame: .zero)
        self.layout = layout
        
        // 文字默认尾部截断
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    public init(_ layoutUpdater: ((inout Layout) -> Void)? = nil) {
        super.init(frame: .zero)
        layoutUpdater?(&layout)
        
        // 文字默认尾部截断
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }

    public convenience init(type buttonType: UIButton.ButtonType) {
        self.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override open func contentRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: layout.contentInsets)
    }

    override open func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let insets = cpfAttributes.imageInsets(in: contentRect.size, of: self)
        return contentRect.inset(by: insets)
    }
    
    override open func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let insets = cpfAttributes.textInsets(in: contentRect.size, of: self)
        return contentRect.inset(by: insets)
    }
    
    open override var isSelected: Bool {
        didSet {
            updateFont()
            invalidateIntrinsicContentSize()
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            updateFont()
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            updateFont()
            invalidateIntrinsicContentSize()
        }
    }

    override open var intrinsicContentSize: CGSize {
        buttonSize()
    }
    
    open override func layoutSubviews() {
        let _ = buttonSize()
        super.layoutSubviews()
    }
    
    // MARK: - Update
    public func updateLayout(_ updater: (inout Layout) -> Void) {
        updater(&layout)
        
        self.invalidateIntrinsicContentSize()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    // MARK: - Font
    
    /// 设置指定状态的字体
    /// - Parameters:
    ///   - font: 指定的字体
    ///   - state: 对应的状态
    public func set(font: UIFont?, for state: UIControl.State) {
        fontInfo[state.rawValue] = font
        updateFont()
    }
    
    /// 指定状态的字体
    /// - 注意：未对任何状态设置过字体时，返回的总是nil
    public func font(for state: UIControl.State) -> UIFont? {
        guard let (_, firstFont) = fontInfo.first else { return nil }
        if let font = fontInfo[state.rawValue] {
            return font
        } else if layout.useFontOfUnHighlightedState, state.contains(.highlighted) {
            var theState = state
            theState.remove(.highlighted)
            if let font = fontInfo[theState.rawValue] {
                return font
            }
        }
        
        // 当前状态找不到字体时，使用normal状态的字体
        if let font = fontInfo[UIControl.State.normal.rawValue] {
            return font
        }
        
        // 无normal字体时，取第一个字体
        return firstFont
    }

    private func updateFont() {
        let oldFont = titleLabel?.font
        let newFont = font(for: state)

        guard let _ = newFont, newFont != oldFont else { return }
        titleLabel?.font = newFont
        invalidateIntrinsicContentSize()
    }
}

extension Button {
    /// 计算指定状态下，指定显示内容时按钮的总尺寸
    /// - Parameters:
    ///   - title: 展示的标题
    ///   - attributedTitle: 展示的属性标题，优先级高于title
    ///   - image: 展示的图像
    ///   - state: 状态，未指定时使用按钮当前状态
    public func buttonSize(of title: String? = nil, attributedTitle: NSAttributedString? = nil, image: UIImage? = nil, state: UIControl.State? = nil) -> CGSize {
        cpfAttributes.buttonSize(
            of: title ?? currentTitle,
            attributedTitle: attributedTitle ?? currentAttributedTitle,
            image: image ?? currentImage,
            button: self,
            state: state ?? self.state
        )
    }
}
