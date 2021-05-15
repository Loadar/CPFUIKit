//
//  AnyListController.swift
//  ListModelTest
//
//  Created by Aaron on 2021/5/13.
//

import Foundation

/// 列表controller顶层协议
public protocol AnyListController: class {
    // 列表项的数据类型(如果需要支持多种类型，转换成同一种类型的数据)
    associatedtype Item
    // list view类型，UITableView或UICollectionView或它们的子类
    associatedtype ListView
    
    /// 当前的列表view(请勿直接设置此项的值)
    var listView: ListView? { get set }
    
    /// 指定闭包返回section的数目，为指定时返回1
    func sectionCount(with closour: @escaping () -> Int)
    /// 指定section的数据列表
    var itemListProviding: ((_ section: Int) -> [Item])? { get set }
    
    /// Cell配置器列表
    var configurers: [AnyListComponentConfigurer] { set get }
    
    /// 获取指定feature的target
    func target<T>(of feature: ListFeature, with type: T.Type) -> T?

//    /// supplementary identifier转换
//    func identifier(with identifier: String, type: ListComponentType.SupplementaryType) -> String
    
//
//    var listScrolledHandler: ((UIScrollView) -> Void)? { get set }
}

extension AnyListController {
    func commonTarget(of feature: ListFeature) -> AnyObject? {
        target(of: feature, with: AnyObject.self)
    }
}

extension AnyListController {
    // 返回指定indexPath的item
    func item(at indexPath: IndexPath) -> Item? {
        guard let list = itemListProviding?(indexPath.section) else { return nil }
        guard 0..<list.endIndex ~= indexPath.item else { return nil }
        return list[indexPath.item]
    }
}

// MARK: - Base
extension AnyListController {
    public func sectionCount(with closour: @escaping () -> Int) {
        target(of: .base, with: AnyBaseTarget.self)?.sectionCountProviding = closour
    }
    
    func itemList(with closour: @escaping (Int) -> [Item]) {
        self.itemListProviding = closour
        target(of: .base, with: AnyBaseTarget.self)?.itemListCountProviding = { closour($0).count }
    }

    func cellIdentifier(with closour: @escaping (IndexPath, Item) -> String) {
        target(of: .base, with: AnyBaseTarget.self)?.cellIdentifierProviding = { [weak self] (indexPath) in
            guard let self = self else { return "" }
            guard let item = self.item(at: indexPath) else { return "" }
            return closour(indexPath, item)
        }
    }
    
    func itemDidSelected(with closour: @escaping (IndexPath, Item) -> Void) {
        target(of: .base, with: AnyBaseTarget.self)?.itemDidSelected = block(with: closour)
    }

    func scrolled(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .base, with: AnyBaseTarget.self)?.scrolled = closour
    }
}

// MARK: - Selectable
extension AnyListController {
    func itemShouldHighlight(with closour: @escaping (IndexPath, Item) -> Bool) {
        target(of: .selectable, with: AnySelectableTarget.self)?.itemShouldHighlight = block(with: closour)
    }
    
    func itemDidHighlight(with closour: @escaping (IndexPath, Item) -> Void) {
        target(of: .selectable, with: AnySelectableTarget.self)?.itemDidHighlight = block(with: closour)
    }
    
    func itemDidUnHighlight(with closour: @escaping (IndexPath, Item) -> Void) {
        target(of: .selectable, with: AnySelectableTarget.self)?.itemDidUnhighlight = block(with: closour)
    }

    func itemShouldSelect(with closour: @escaping (IndexPath, Item) -> Bool) {
        target(of: .selectable, with: AnySelectableTarget.self)?.itemShouldSelect = block(with: closour)
    }
    
    func itemShouldDeselect(with closour: @escaping (IndexPath, Item) -> Bool) {
        target(of: .selectable, with: AnySelectableTarget.self)?.itemShouldDeselect = block(with: closour)
    }
    
    func itemDidDeselected(with closour: @escaping (IndexPath, Item) -> Void) {
        target(of: .selectable, with: AnySelectableTarget.self)?.itemDidDeselected = block(with: closour)
    }
    
    private func block(with closour: @escaping (IndexPath, Item) -> Bool) -> ((IndexPath) -> Bool) {
        return { [weak self] (indexPath) in
            guard let self = self else { return false }
            guard let item = self.item(at: indexPath) else { return false }
            return closour(indexPath, item)
        }
    }
    
    private func block(with closour: @escaping (IndexPath, Item) -> Void) -> ((IndexPath) -> Void) {
        return { [weak self] (indexPath) in
            guard let self = self else { return }
            guard let item = self.item(at: indexPath) else { return }
            return closour(indexPath, item)
        }
    }
}

// MARK: - Supplementary
extension AnyListController {
    // supplementary identifier转换
    internal func identifier(with identifier: String, type: ListComponentType.SupplementaryType) -> String {
        if let configurer = configurers.first(where: { $0.type == .supplementary(type) && $0.originalId == identifier }) {
            return configurer.id
        }
        return identifier
    }
}

extension AnyListController {
    func headerIdentifier(with closour: @escaping (IndexPath) -> String) {
        target(of: .supplementary, with: AnySupplementaryTarget.self)?.headerIdentifierProviding = { [weak self] (indexPath) -> String in
            guard let self = self else { return "" }
            return self.identifier(with: closour(indexPath), type: .header)
        }
    }
    
    func footerIdentifier(with closour: @escaping (IndexPath) -> String) {
        target(of: .supplementary, with: AnySupplementaryTarget.self)?.footerIdentifierProviding = { [weak self] (indexPath) -> String in
            guard let self = self else { return "" }
            return self.identifier(with: closour(indexPath), type: .footer)
        }
    }
    
    private func enableCellConfiguring() {
        guard let target = target(of: .base, with: AnyBaseTarget.self) else { return }
        
        /// 设置第一个cell configurer对应的id为默认id
        if target.defaultCellIdentifier == nil, let item = configurers.first(where: { $0.type == .cell }) {
            target.defaultCellIdentifier = item.id
        }
        
        guard target.cellConfiguring == nil else { return }
        target.cellConfiguring = { [weak self] (indexPath, cell) in
            guard let self = self else { return }
            guard let target = self.target(of: .base, with: AnyBaseTarget.self) else { return }
            guard let item = self.item(at: indexPath) else { return}
            let id = target.cellIdentifierProviding?(indexPath) ?? target.defaultCellIdentifier
            guard let configurer = self.configurers.first(where: { $0.id == id && $0.type == .cell }) as? PartialCellConfigurer<Item> else { return }
            configurer.configure(cell: cell, at: indexPath, for: item)
        }
    }
    
    private func enableHeaderConfiguring() {
        guard let target = target(of: .supplementary, with: AnySupplementaryTarget.self) else { return }
        
        /// 设置第一个cell configurer对应的id为默认id
        if target.defaultHeaderIdentifier == nil, let item = configurers.first(where: { $0.type == .supplementary(.header) }) {
            target.defaultHeaderIdentifier = item.id
        }
        
        guard target.headerConfiguring == nil else { return }
        target.headerConfiguring = { [weak self] (indexPath, header) in
            guard let self = self else { return }
            guard let target = self.target(of: .supplementary, with: AnySupplementaryTarget.self) else { return }
            let id = target.headerIdentifierProviding?(indexPath) ?? target.defaultHeaderIdentifier
            guard let configurer = self.configurers.first(where: { $0.id == id && $0.type == .supplementary(.header) }) as? PartialSupplementaryViewConfigurer else { return }
            configurer.configure(view: header, at: indexPath)
        }
    }
    
    private func enableFooterConfiguring() {
        guard let target = target(of: .supplementary, with: AnySupplementaryTarget.self) else { return }
        
        /// 设置第一个cell configurer对应的id为默认id
        if target.defaultFooterIdentifier == nil, let item = configurers.first(where: { $0.type == .supplementary(.footer) }) {
            target.defaultFooterIdentifier = item.id
        }
        
        guard target.footerConfiguring == nil else { return }
        target.footerConfiguring = { [weak self] (indexPath, header) in
            guard let self = self else { return }
            guard let target = self.target(of: .supplementary, with: AnySupplementaryTarget.self) else { return }
            let id = target.footerIdentifierProviding?(indexPath) ?? target.defaultFooterIdentifier
            guard let configurer = self.configurers.first(where: { $0.id == id && $0.type == .supplementary(.footer) }) as? PartialSupplementaryViewConfigurer else { return }
            configurer.configure(view: header, at: indexPath)
        }
    }

    func enableConfiguring(of type: ListComponentType) {
        switch type {
        case .cell:
            enableCellConfiguring()
        case .supplementary(let supplementaryType):
            switch supplementaryType {
            case .header:
                enableHeaderConfiguring()
            case .footer:
                enableFooterConfiguring()
            }
        }
    }
}

// MARK: - Link
extension AnyListController where ListView: UICollectionView {
    /// 关联collectionView, 设置datasource及delegate
    func link(_ listView: ListView, registerCell: Bool = true) {
        self.listView = listView
        listView.dataSource = self as? UICollectionViewDataSource
        listView.delegate = self as? UICollectionViewDelegateFlowLayout
    }
}

extension AnyListController where ListView: UITableView {
    /// 关联tableView, 设置datasource及delegate
    func link(_ listView: ListView, registerCell: Bool = true) {
        self.listView = listView
        listView.dataSource = self as? UITableViewDataSource
        listView.delegate = self as? UITableViewDelegate
    }
}

// MARK: - Layout
extension AnyListController where ListView: UICollectionView {
    func cellSize(with closour: @escaping (IndexPath) -> CGSize) {
        target(of: .layout, with: CollectionLayoutTarget.self)?.cellSizeProviding = closour
    }
    
    func sectionInsets(with closour: @escaping (Int) -> UIEdgeInsets) {
        target(of: .layout, with: CollectionLayoutTarget.self)?.sectionInsetsProviding = closour
    }
    
    func lineSpacing(with closour: @escaping (Int) -> CGFloat) {
        target(of: .layout, with: CollectionLayoutTarget.self)?.lineSpacingProviding = closour
    }
    
    func interitemSpacing(with closour: @escaping (Int) -> CGFloat) {
        target(of: .layout, with: CollectionLayoutTarget.self)?.interitemSpacingProviding = closour
    }
    
    func headerSize(with closour: @escaping (Int) -> CGSize) {
        target(of: .layout, with: CollectionLayoutTarget.self)?.headerSizeProviding = closour
    }
    
    func footerSize(with closour: @escaping (Int) -> CGSize) {
        target(of: .layout, with: CollectionLayoutTarget.self)?.footerSizeProviding = closour
    }
}

extension AnyListController where ListView: UITableView {
    func rowHeight(with closour: @escaping (IndexPath) -> CGFloat) {
        target(of: .layout, with: TableLayoutTarget.self)?.rowHeightProviding = closour
    }

    func headerHeight(with closour: @escaping (Int) -> CGFloat) {
        target(of: .layout, with: TableLayoutTarget.self)?.headerHeightProviding = closour
    }
    
    func footerHeight(with closour: @escaping (Int) -> CGFloat) {
        target(of: .layout, with: TableLayoutTarget.self)?.footerHeightProviding = closour
    }
}

// MARK: - Scrollable
extension AnyListController where ListView: UIScrollView {
    func willBeginDecelerating(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.willBeginDecelerating = closour
    }
    
    func didEndDecelerating(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.didEndDecelerating = closour
    }

    func willBeginDragging(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.willBeginDragging = closour
    }
    
    func willEndDragging(with closour: @escaping (UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>?) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.willEndDragging = closour
    }

    func didEndDragging(with closour: @escaping (UIScrollView, Bool) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.didEndDragging = closour
    }

    func didEndScrollingAnimation(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.didEndScrollingAnimation = closour
    }
    
    func shouldScrollToTop(with closour: @escaping (UIScrollView) -> Bool) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.shouldScrollToTop = closour
    }

    func didScrollToTop(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.didScrollToTop = closour
    }
    
    func didZoom(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.didZoom = closour
    }

    func viewForZooming(with closour: @escaping (UIScrollView) -> UIView?) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.viewForZooming = closour
    }


    func willBeginZooming(with closour: @escaping (UIScrollView, UIView?) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.willBeginZooming = closour
    }
    
    func didEndZooming(with closour: @escaping (UIScrollView, UIView?, CGFloat) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.didEndZooming = closour
    }
    
    @available(iOS 11, *)
    func adjustedContentInsetChanged(with closour: @escaping (UIScrollView) -> Void) {
        target(of: .scrollable, with: AnyScrollableTarget.self)?.adjustedContentInsetChanged = closour
    }
}
