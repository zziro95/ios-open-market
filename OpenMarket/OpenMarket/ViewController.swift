//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let listView = ListViewController()
    let collectionView = CollectionViewController()
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
        addChildView()
    }
    
    private func addChildView() {
        addChild(listView)
        addChild(collectionView)
        
        self.view.addSubview(listView.view)
        self.view.addSubview(collectionView.view)
        
        configureTableContainerConstraint(for: listView.view)
        configureTableContainerConstraint(for: collectionView.view)
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }

    private func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(changeViewStyle(_ :)), for: .valueChanged)
    }
    
    private func configureTableContainerConstraint(for container: UIView) {
        container.translatesAutoresizingMaskIntoConstraints = false
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
            listView.view.isHidden = false
            collectionView.view.isHidden = true
        } else {
            listView.view.isHidden = true
            collectionView.view.isHidden = false
        }
    }
}

