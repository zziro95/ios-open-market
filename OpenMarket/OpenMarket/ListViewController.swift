//
//  ListViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/29.
//

import UIKit

final class ListViewController: UIViewController {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureConstraintToSafeArea(for: tableView)
    }
    
    private func configureTableView() {
 //       tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
