//
//  ImageGridVC.swift
//  NIST
//
//  Created by Miguel Fraire on 7/30/21.
//

import UIKit

class ImageGridVC: NDataLoadingVC {
    
    enum Section { case main }
    
    private var items: [Item]       = []
    private var page                = 1
    private var hasMoreData         = true
    private var isSearching         = false
    private var isLoadingMoreData   = false
    
    private var searchTerm: String?
    private var collectionView:  UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    init(searchTerm: String) {
        super.init(nibName: nil, bundle: nil)
        self.searchTerm = searchTerm
        title = searchTerm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getData(searchTerm: searchTerm ?? "", page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
            collectionView.frame = view.frame
            collectionView.collectionViewLayout = createThreeColumnFlowLayout()
        }
    }
    
    //MARK: - UI Configuration Methods
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createThreeColumnFlowLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
 
        let viewWidth = view.frame.width,
            numberOfItemsPerRow: CGFloat = viewWidth < view.frame.height ? 3 : 4,
            minimumItemSpacing: CGFloat = 10,
            padding: CGFloat = 5,
            availableWidth = viewWidth - (padding * 2) - (minimumItemSpacing * 2),
            itemWidth = availableWidth / numberOfItemsPerRow
            
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.sectionInsetReference = .fromSafeArea
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.scrollDirection = .vertical
        
        return flowLayout
    }
    
    //MARK: - Networking Method
    
    private func getData(searchTerm: String, page: Int) {
        showLoadingView()
        isLoadingMoreData = true
        
        NetworkManager.shared.getData(for: searchTerm, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let data):
                self.updateUI(with: data.collection)
                
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Dismiss")
            }
            self.isLoadingMoreData = false
        }
    }
    
    
    private func updateUI(with collection: Collection) {
        let items = collection.items
        self.items.append(contentsOf: items)
        
        if self.items.count >= collection.metadata.totalHits { self.hasMoreData = false }
        
        if self.items.isEmpty {
            DispatchQueue.main.async { self.showEmptyStateView(with: "There are no images to display...", in: self.view) }
            return
        }
        
        self.updateData(on: self.items)
    }
    
    //MARK: - Data Source Methods
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
            cell.set(imageURL: item.links[0])
            return cell
        })
    }
    
    private func updateData(on items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}

//MARK: - Extension: UICollectionViewDelegate

extension ImageGridVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMoreData, !isLoadingMoreData else { return }
            page += 1
            getData(searchTerm: searchTerm ?? "", page: page)
            print("Loading More Data...")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let destVC = ImageDetailVC(item: item)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
