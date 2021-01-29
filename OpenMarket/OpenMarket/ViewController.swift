//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
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
        addChildView()
    }
    
    private func addChildView() {
        addChild(listView)
        addChild(collectionView)
        
        self.view.addSubview(listView.view)
        self.view.addSubview(collectionView.view)
        
        configureConstraintToSafeArea(for: listView.view)
        configureConstraintToSafeArea(for: collectionView.view)
    }
    
    private func configureNavigationBar() {
        configureSegmentedControl()
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }

    private func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(changeViewStyle(_ :)), for: .valueChanged)
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

extension UIViewController {
    func configureConstraintToSafeArea(for ojbect: UIView) {
        ojbect.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(ojbect)
        
        NSLayoutConstraint.activate([
            ojbect.topAnchor.constraint(equalTo: safeArea.topAnchor),
            ojbect.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            ojbect.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            ojbect.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

