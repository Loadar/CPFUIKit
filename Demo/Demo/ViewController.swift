//
//  ViewController.swift
//  Demo
//
//  Created by Aaron on 2023/3/30.
//

import UIKit
import SnapKit
import Then

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
