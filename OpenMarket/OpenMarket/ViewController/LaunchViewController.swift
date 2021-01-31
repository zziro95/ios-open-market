//
//  LaunchViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLaunchImage()
        setUpData()
    }
    
    private func configureLaunchImage() {
        let launchImage = UIImageView()
        let safeArea = view.safeAreaLayoutGuide
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        launchImage.image = UIImage(named: "launchScreen")
        launchImage.contentMode = .scaleAspectFit
        view.addSubview(launchImage)
        
        NSLayoutConstraint.activate([
            launchImage.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            launchImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            launchImage.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            launchImage.heightAnchor.constraint(equalTo: launchImage.widthAnchor)
        ])
    }
    
    private func setUpData() {
        let page = OpenMarketData.shared.currentPage
        OpenMarketJSONDecoder<ProductList>.decodeData(about: .loadPage(page: page)) { result in
            switch result {
            case .success(let data):
                OpenMarketData.shared.productList.append(contentsOf: data.items)
                OpenMarketData.shared.currentPage += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.goOpenMarketView()
            }
        }
    }
    
    private func goOpenMarketView() {
        if let openMarketViewController = storyboard?.instantiateViewController(identifier: "OpenMarketNavigation") {
            openMarketViewController.modalPresentationStyle = .overFullScreen
            present(openMarketViewController, animated: false, completion: nil)
        }
    }
}