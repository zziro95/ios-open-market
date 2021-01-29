//
//  ListTableViewCell.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/29.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }

    let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()
    
    let priceBeforeSaleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraint()
    }
    
    private func configureConstraint() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(thumbnailView)
        contentView.addSubview(priceBeforeSaleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)

        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thumbnailView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            thumbnailView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.12),
            thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor, multiplier: 1),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            priceBeforeSaleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            priceBeforeSaleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),

            priceLabel.leadingAnchor.constraint(equalTo: priceBeforeSaleLabel.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
