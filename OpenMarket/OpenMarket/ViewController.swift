//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    let tableContainer: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let collectionContainer: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "LIST", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "GRID", at: 1, animated: true)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.backgroundColor = .systemBlue
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSegmentedControl()
        configureTableContainerConstraint(for: tableContainer)
        configureTableContainerConstraint(for: collectionContainer)
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationController?.navigationBar.items = [navigationItem]
    }

    private func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(changeViewStyle(_ :)), for: .valueChanged)
    }
    
    private func configureTableContainerConstraint(for container: UIView) {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: safeArea.topAnchor),
            container.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc private func changeViewStyle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tableContainer.isHidden = false
            collectionContainer.isHidden = true
        } else {
            tableContainer.isHidden = true
            collectionContainer.isHidden = false
        }
    }
}

