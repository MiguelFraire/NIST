//
//  ImageDetailVC.swift
//  NIST
//
//  Created by Miguel Fraire on 7/30/21.
//

import UIKit

class ImageDetailVC: NDataLoadingVC {
    
    private let scrollView          = UIScrollView()
    private let contentView         = UIView()
    private let titleLabel          = NTitleLabel(textAlignment: .center, fontSize: 25)
    private let imageView           = NImageView(frame: .zero)
    private let descriptionLabel    = NBodyLabel(textAlignment: .center)
    private let creatorLabel        = NLabel()
    private let locationLabel       = NLabel()

    private var itemViews: [UIView] = []
    private var item: Item?
    
    init(item: Item){
        super.init(nibName: nil, bundle: nil)
        self.item = item
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureUIElements(with: item)
        layoutUIElements()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func configureUIElements(with item: Item?) {
        guard let item = item else { return } 
        let data = item.data.first
        let urlString = item.links[0].href
        
        self.titleLabel.text = data?.title
        self.titleLabel.numberOfLines = 2
        self.titleLabel.minimumScaleFactor = 0.60
        
        self.imageView.downloadImage(fromURL: urlString)
        
        self.descriptionLabel.lineBreakMode = .byWordWrapping
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.text = data?.description508 ?? "Description is not available"
        
        self.creatorLabel.set(itemInfoType: .creator, string: data?.photographer)
        
        self.locationLabel.set(itemInfoType: .location, string: data?.location)
    }
    
    private func layoutUIElements() {
        let padding: CGFloat = 20
        
        itemViews = [titleLabel, imageView, descriptionLabel, creatorLabel, locationLabel]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            if itemView == imageView {
                NSLayoutConstraint.activate([
                    itemView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
                    itemView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
                ])
            }else {
                NSLayoutConstraint.activate([
                    itemView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
                    itemView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
                ])
            }
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            creatorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            creatorLabel.heightAnchor.constraint(equalToConstant: padding),

            locationLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: padding),
            locationLabel.heightAnchor.constraint(equalToConstant: padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 40),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),

        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
