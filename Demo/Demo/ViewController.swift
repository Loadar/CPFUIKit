//
//  ViewController.swift
//  Demo
//
//  Created by Aaron on 2023/3/30.
//

import UIKit
import SnapKit
import Then
import CPFUIKit

class ViewController: UIViewController {
    private enum Config {
        /// 特性列表
        static var features: [Feature] {
            [.button]
        }
    }

    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.updateConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        
        /// 原站图片提示
        let sourceImageTipsButton = Button {
            $0.imageSize = CGSize(width: 6, height: 6)
            $0.interSpace = 4
            $0.size = CGSize(width: 74, height: 22)
        }
        view.addSubview(sourceImageTipsButton)
        sourceImageTipsButton.backgroundColor = .black.withAlphaComponent(0.4)
        sourceImageTipsButton.layer.cornerRadius = 6
        sourceImageTipsButton.clipsToBounds = true
        sourceImageTipsButton.titleLabel?.font = .systemFont(ofSize: 12)
        sourceImageTipsButton.setTitleColor(.white, for: .normal)
        sourceImageTipsButton.setTitle("原站图片", for: .normal)
        
        let image = UIGraphicsImageRenderer(size: CGSize(width: 6, height: 6)).image { context in
            UIColor.green.setFill()
            UIRectFill(CGRect(origin: .zero, size: CGSize(width: 6, height: 6)))
        }
        sourceImageTipsButton.setImage(image, for: .normal)

        sourceImageTipsButton.frame = CGRect(x: 20, y: 100, width: 74, height: 22)
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Config.features.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.do {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .black
            
            let features = Config.features
            if indexPath.item < features.count {
                $0.text = features[indexPath.item].title
            } else {
                $0.text = "-"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let features = Config.features
        guard indexPath.item < features.count else { return }

        switch features[indexPath.item] {
        case .button:
            present(ButtonViewController(), animated: true)
        }
    }
}
