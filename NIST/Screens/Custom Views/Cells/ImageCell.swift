//
//  ImageCell.swift
//  NIST
//
//  Created by Miguel Fraire on 7/30/21.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let reuseID = "ImageCell"
    private let imageView = NImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = .brandGreen
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageURL: Link) {
        imageView.downloadImage(fromURL: imageURL.href)
    }
    
    private func configure() {
        addSubviews(imageView)
        
        let padding: CGFloat = 6
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
}
