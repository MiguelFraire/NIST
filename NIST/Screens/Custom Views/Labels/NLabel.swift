//
//  NLabel.swift
//  NIST
//
//  Created by Miguel Fraire on 7/30/21.
//


import UIKit

enum ItemType {
    case creator, location
}

class NLabel: UIView {

    private let symbolImageView = UIImageView()
    private let titleLabel = NTitleLabel(textAlignment: .left, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(symbolImageView, titleLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    func set(itemInfoType: ItemType, string: String?) {
        switch itemInfoType {
        case .creator:
            symbolImageView.image = UIImage(systemName: "person.fill")
            titleLabel.text = string ?? "Photographer is not available"
        case .location:
            symbolImageView.image = UIImage(systemName: "mappin.and.ellipse")
            titleLabel.text = string ?? "Location is not available"
        }
    }
}
