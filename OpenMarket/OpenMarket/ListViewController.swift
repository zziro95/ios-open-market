//
//  ListViewController.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/29.
//

import UIKit

final class ListViewController: UIViewController {
    let tableView = UITableView()
    var productList: ProductList? = nil
    let currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setUpdata()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        configureConstraintToSafeArea(for: tableView)
    }
    
    private func setUpdata() {
        loadPage(number: 1) { result in
            switch result {
            case .success(let data):
                self.productList = data
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productList = productList else {
            return 0
        }
        return productList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier) as? ListTableViewCell, let product = productList?.items[indexPath.row], let price = product.price, let currency = product.currency, let stock = product.stock else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = product.title
        cell.stockLabel.text = "잔여수량 : \(stock)"
        cell.accessoryType = .disclosureIndicator

        if let salePrice = product.discountedPrice {
            cell.priceBeforeSaleLabel.text = "\(currency) \(price)"
            cell.priceLabel.text = "\(currency) \(salePrice)"
        } else {
            cell.priceLabel.text = "\(currency) \(price)"
        }
        
        guard let imageURLText = product.thumbnailURLs?.first, let url = URL(string: imageURLText) else {
            return cell
        }
        
        DispatchQueue.main.async {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                cell.imageView?.image = image
            } else {
                cell.imageView?.image = nil
            }
        }
        return cell
    }
}
//
//extension UIImage {
//    func resizeImage(targetSize: CGSize) -> UIImage {
//        let size = self.size
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        self.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
//}
