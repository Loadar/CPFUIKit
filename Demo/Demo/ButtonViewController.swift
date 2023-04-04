//
//  ButtonViewController.swift
//  Demo
//
//  Created by Aaron on 2023/3/30.
//

import UIKit
import CPFUIKit
import SnapKit

/// 按钮功能测试
final class ButtonViewController: UIViewController {
    private enum Property: CaseIterable, Hashable {
        case state
        case title
        case image
        case font
        
        case axis
        case priority
        case interSpace
        case imageSize
        case maxTextWidth
        case size
        case minSize
        case maxSize
        case contentInsets
        case horizontalContentAlignment
        case verticalContentAlignment
        case useFontOfUnHighlightedState
        
        var title: String {
            switch self {
            case .state: return "状态"
            case .title: return "标题"
            case .image: return "图标"
            case .font: return "字体"
            
            case .axis: return "轴"
            case .priority: return "元素优先级"
            case .interSpace: return "元素间距"
            case .imageSize: return "图标尺寸"
            case .maxTextWidth: return "最大文字宽度"
            case .size: return "总尺寸"
            case .minSize: return "最小总尺寸"
            case .maxSize: return "最大总尺寸"
            case .contentInsets: return "内容内边距"
            case .horizontalContentAlignment: return "水平方向元素排列"
            case .verticalContentAlignment: return "垂直方向元素排列"
            case .useFontOfUnHighlightedState: return "非高亮字体"
            }
        }
    }
    
    private let button = Button()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var propertyInfos = [Property: String]()
    private var statePropertyInfo = [UInt: [Property: String]]()
    private var currentState: UIControl.State? = .normal
    
    private func saveInfo(for state: UIControl.State) {
        let infos = propertyInfos.filter {
            switch $0.key {
            case .title, .image, .font:
                return true
            default:
                return false
            }
        }
        statePropertyInfo[state.rawValue] = infos
    }
    private func restoreInfo(for state: UIControl.State) {
        let properties: [Property] = [.title, .image, .font]
        properties.forEach {
            propertyInfos[$0] = statePropertyInfo[state.rawValue]?[$0] ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        view.addSubview(tableView)
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.snp.updateConstraints { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(view).multipliedBy(0.3)
        }
        button.snp.updateConstraints { make in
            make.center.equalTo(layoutGuide)
        }
        tableView.snp.updateConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(layoutGuide.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.backgroundColor = .white
        button.backgroundColor = .purple

        tableView.do {
            $0.rowHeight = 60
            $0.register(PropertyCell.self, forCellReuseIdentifier: String(describing: PropertyCell.self))
            $0.dataSource = self
            $0.delegate = self
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            guard let keyboardBounds = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            self.tableView.contentInset.bottom = keyboardBounds.height
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.contentInset.bottom = 0
        }
        
        // 初始数据
        propertyInfos[.state] = "normal"
        currentState = .normal
        propertyInfos[.title] = "测试"
        propertyInfos[.image] = "00ff00,16,16"
        propertyInfos[.font] = "16,medium"
        propertyInfos[.axis] = "horizontal"
        propertyInfos[.priority] = "image"
        propertyInfos[.interSpace] = "4"
        propertyInfos[.imageSize] = "10,20"
        propertyInfos[.maxTextWidth] = "0"
        propertyInfos[.size] = "0,0"
        propertyInfos[.minSize] = "0,0"
        propertyInfos[.maxSize] = "0,0"
        propertyInfos[.contentInsets] = "0,0,0,0"
        propertyInfos[.horizontalContentAlignment] = "center"
        propertyInfos[.verticalContentAlignment] = "center"
        propertyInfos[.useFontOfUnHighlightedState] = "true"
        
        propertyInfos.forEach {
            let _ = validate(info: $0.value, of: $0.key, toUpdate: true)
        }
    }
}

extension ButtonViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Property.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PropertyCell.self), for: indexPath)
        if let propertyCell = cell as? PropertyCell {
            let property = Property.allCases[indexPath.item]
            propertyCell.titleLabel.text = property.title
            
            let info = propertyInfos[property] ?? ""
            propertyCell.textField.text = info
            if validate(info: info, of: property) {
                propertyCell.textField.backgroundColor = .clear
            } else {
                propertyCell.textField.backgroundColor = .red.withAlphaComponent(0.2)
            }
            
            switch property {
            case .title, .image, .font:
                propertyCell.textField.isUserInteractionEnabled = currentState != nil
            default:
                break
            }
            
            propertyCell.textDidChanged = { [weak self] cell in
                guard let self = self else { return }
                guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                let property = Property.allCases[indexPath.item]
                
                let oldInfo = self.propertyInfos[property]
                let newInfo = cell.textField.text ?? ""
                guard oldInfo != newInfo else { return }
                self.propertyInfos[property] = newInfo
                let _ = self.validate(info: newInfo, of: property, toUpdate: true)
                if case .state = property {
                    self.tableView.reloadData()
                } else {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    private func validate(info: String, of property: Property, toUpdate: Bool = false) -> Bool {
        switch property {
        case .state:
            let oldState = button.state
            let state: UIControl.State
            switch info {
            case "normal":
                state = .normal
                if toUpdate {
                    button.isSelected = false
                    button.isEnabled = true
                    button.isHighlighted = false
                }
            case "highlighted":
                state = .highlighted
                if toUpdate {
                    button.isSelected = false
                    button.isEnabled = true
                    button.isHighlighted = true
                }
            case "selected":
                state = .selected
                if toUpdate {
                    button.isSelected = true
                    button.isEnabled = true
                    button.isHighlighted = false
                }
            case "selected,highlighted", "highlighted,selected":
                state = [.selected, .highlighted]
                if toUpdate {
                    button.isSelected = true
                    button.isEnabled = true
                    button.isHighlighted = true
                }
            case "disabled":
                state = .disabled
                if toUpdate {
                    button.isEnabled = false
                }
            default:
                if toUpdate {
                    currentState = nil
                }
                return false
            }
            
            currentState = state
            if toUpdate {
                saveInfo(for: oldState)
                restoreInfo(for: state)
                
                propertyInfos.forEach {
                    switch $0.key {
                    case .state:
                        break
                    default:
                        let _ = validate(info: $0.value, of: $0.key, toUpdate: true)
                    }
                }
            }
            
            return true
        case .title:
            if toUpdate {
                button.setTitle(info, for: button.state)
            }
            return true
        case .image:
            if info.isEmpty {
                if toUpdate {
                    button.setImage(nil, for: button.state)
                }
                return true
            }
            
            let components = info.components(separatedBy: ",")
            guard components.count == 3 else { return false }
            let colorText = components[0]
            let widthText = components[1]
            let heightText = components[2]
            
            guard let color = UIColor(hex: colorText) else { return false }
            guard let width = Int(widthText), let height = Int(heightText), width > 0, height > 0 else { return false }
            
            if toUpdate {
                let image = image(with: color, size: CGSize(width: width, height: height))
                button.setImage(image, for: button.state)
            }
            return true
        case .font:
            if info.isEmpty {
                if toUpdate {
                    button.set(font: nil, for: button.state)
                }
                return true
            }
            
            let components = info.components(separatedBy: ",")
            guard components.count == 2 else { return false }
            guard let fontSize = Int(components[0]), fontSize > 0 else { return false }
            
            let weight: UIFont.Weight
            switch components[1] {
            case "ultraLight":
                weight = .ultraLight
            case "thin":
                weight = .thin
            case "light":
                weight = .light
            case "regular":
                weight = .regular
            case "medium":
                weight = .medium
            case "semibold":
                weight = .semibold
            case "bold":
                weight = .bold
            case "heavy":
                weight = .heavy
            case "black":
                weight = .black
            default:
                return false
            }

            if toUpdate {
                let font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: weight)
                button.set(font: font, for: button.state)
            }

            return true
        case .axis:
            switch info {
            case "horizontal":
                if toUpdate {
                    button.updateLayout {
                        $0.axis = .horizontal
                    }
                }
                return true
            case "vertical":
                if toUpdate {
                    button.updateLayout {
                        $0.axis = .vertical
                    }
                }
                return true
            default:
                return false
            }
        case .priority:
            switch info {
            case "image":
                if toUpdate {
                    button.updateLayout {
                        $0.priority = .image
                    }
                }
                return true
            case "text":
                if toUpdate {
                    button.updateLayout {
                        $0.priority = .text
                    }
                }
                return true
            default:
                return false
            }
        case .interSpace:
            guard let value = Int(info) else {
                return false
            }
            
            if toUpdate {
                button.updateLayout {
                    $0.interSpace = CGFloat(value)
                }
            }
            return true
        case .imageSize:
            let components = info.components(separatedBy: ",")
            guard components.count == 2 else {
                return false
            }
            guard let width = Int(components[0]), let height = Int(components[1]) else {
                return false
            }
            
            if toUpdate {
                button.updateLayout {
                    $0.imageSize = CGSize(width: width, height: height)
                }
            }
            return true
        case .maxTextWidth:
            guard let value = Int(info) else {
                return false
            }
            
            if toUpdate {
                button.updateLayout {
                    $0.maxTextWidth = CGFloat(value)
                }
            }
            return true
        case .size:
            let components = info.components(separatedBy: ",")
            guard components.count == 2 else {
                return false
            }
            guard let width = Int(components[0]), let height = Int(components[1]) else {
                return false
            }
            
            if toUpdate {
                button.updateLayout {
                    $0.size = CGSize(width: width, height: height)
                }
            }
            return true
        case .minSize:
            let components = info.components(separatedBy: ",")
            guard components.count == 2 else {
                return false
            }
            guard let width = Int(components[0]), let height = Int(components[1]) else {
                return false
            }
            
            if toUpdate {
                button.updateLayout {
                    $0.minSize = CGSize(width: width, height: height)
                }
            }
            return true
        case .maxSize:
            let components = info.components(separatedBy: ",")
            guard components.count == 2 else {
                return false
            }
            guard let width = Int(components[0]), let height = Int(components[1]) else {
                return false
            }
            
            if toUpdate {
                button.updateLayout {
                    $0.maxSize = CGSize(width: width, height: height)
                }
            }
            return true
        case .contentInsets:
            let components = info.components(separatedBy: ",")
            guard components.count == 4 else {
                return false
            }
            guard let top = Int(components[0]), let left = Int(components[1]), let bottom = Int(components[2]), let right = Int(components[3]) else {
                return false
            }
            
            if toUpdate {
                button.updateLayout {
                    $0.contentInsets = UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
                }
            }
            return true
        case .horizontalContentAlignment:
            switch info {
            case "leading":
                if toUpdate {
                    button.updateLayout {
                        $0.horizontalContentAlignment = .leading
                    }
                }
                return true
            case "center":
                if toUpdate {
                    button.updateLayout {
                        $0.horizontalContentAlignment = .center
                    }
                }
                return true
            case "trailing":
                if toUpdate {
                    button.updateLayout {
                        $0.horizontalContentAlignment = .trailing
                    }
                }
                return true
            default:
                return false
            }
        case .verticalContentAlignment:
            switch info {
            case "leading":
                if toUpdate {
                    button.updateLayout {
                        $0.verticalContentAlignment = .leading
                    }
                }
                return true
            case "center":
                if toUpdate {
                    button.updateLayout {
                        $0.verticalContentAlignment = .center
                    }
                }
                return true
            case "trailing":
                if toUpdate {
                    button.updateLayout {
                        $0.verticalContentAlignment = .trailing
                    }
                }
                return true
            default:
                return false
            }
        case .useFontOfUnHighlightedState:
            switch info {
            case "true":
                if toUpdate {
                    button.updateLayout {
                        $0.useFontOfUnHighlightedState = true
                    }
                }
                return true
            case "false":
                if toUpdate {
                    button.updateLayout {
                        $0.useFontOfUnHighlightedState = false
                    }
                }
                return true
            default:
                return false
            }
        }
    }
}

extension ButtonViewController {
    final class PropertyCell: UITableViewCell, UITextFieldDelegate {
        let titleLabel = UILabel()
        let textField = UITextField()
        
        var textDidChanged: ((PropertyCell) -> Void)?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configureCell()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureCell() {
            contentView.addSubview(titleLabel)
            contentView.addSubview(textField)
            
            titleLabel.snp.updateConstraints { make in
                make.left.equalTo(16)
                make.width.equalTo(140)
                make.centerY.equalTo(self)
            }
            textField.snp.updateConstraints { make in
                make.left.equalTo(titleLabel.snp.right).offset(10)
                make.centerY.equalTo(titleLabel)
                make.height.equalTo(self)
                make.right.equalTo(-16)
            }
            
            titleLabel.do {
                $0.font = .systemFont(ofSize: 16)
                $0.textColor = .black
            }
            textField.do {
                $0.font = .systemFont(ofSize: 20)
                $0.textColor = .green
                $0.delegate = self
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            DispatchQueue.main.async {
                self.textField.resignFirstResponder()
            }
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            textDidChanged?(self)
        }
    }
}

extension ButtonViewController {
    private func image(with color: UIColor, size: CGSize) -> UIImage? {
        guard size.width > 0, size.height > 0 else {
            return UIImage()
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        format.scale = UIScreen.main.scale

        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            color.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
        }
    }
}
