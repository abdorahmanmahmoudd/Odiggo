//
//  HomeViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    /// UI Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchTextField: OTextField!
    
    /// Properties
    var viewModel: HomeViewModel!
    
    private var listIsFetched = false
        
    /// Prototype cell used to calculate the sizes
    private var prototypeCell: HomeCollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        styleNavigationItem()
        bindObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !listIsFetched {
            listIsFetched = true
            viewModel.fetchHome()
        }
    }

    private func styleNavigationItem() {
        let kia = UIBarButtonItem.customBarButtonItem(image: UIImage(named: "kia-red"),
                                                              title: nil, selector: nil, target: nil)
        navigationItemStyle = NavigationItemStyle.homePageStyle(items: [kia])
    }
    
    private func configureViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: HomeCollectionViewCell.identifier, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        searchTextField.textfieldType = .searchField
        searchTextField.setPlaceHolder(text: "HOME_SEARCHBAR_PLACEHOLDER".localized)
    }
    
    private func bindObservables() {
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            switch self.viewModel.state {
            
            case .initial, .refreshing:
                debugPrint("initial & refreshing HomeViewController")
                
            case .loading:
                debugPrint("loading HomeViewController")
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result HomeViewController")
                self.showLoadingIndicator(visible: false)
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func searchTextFieldTapped(_ sender: Any) {
        debugPrint("searchTextFieldTapped")
    }

}

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCollectionViewCell else {
            fatalError("Couldn't dequeue a cell of type \(HomeCollectionViewCell.self)")
        }
        cell.configure(viewModel.itemForIndexPath(indexPath),
                       HomeColorsCollection.getNextColor(indexedBy: indexPath.row),
                       HomeColorsCollection.getDescription(indexPath.item))
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel.itemForIndexPath(indexPath) else {
            return
        }
        (coordinator as? HomeCoordinator)?.didSelectTopCategory(item)
    }
}

// MARK: - PinterestLayoutDelegate
extension HomeViewController: PinterestLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        /// If there is no prototype yet, create one
        if prototypeCell == nil {
            guard let cell = UINib(nibName: HomeCollectionViewCell.identifier, bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? HomeCollectionViewCell else {
                
                fatalError("\(HomeCollectionViewCell.identifier) Should be there!")
            }
            prototypeCell = cell
        }
        
        /// Get the cell prototype
        /// If there is no size cached for the cell, calculate it
        /// Otherwise return the cached size
        guard let cell = prototypeCell, viewModel.getSize(for: indexPath) == nil else {
            return viewModel.getSize(for: indexPath)?.height ?? 50
        }
        
        /// configure cell with data
        cell.configure(viewModel.itemForIndexPath(indexPath),
                       HomeColorsCollection.getNextColor(indexedBy: indexPath.row),
                       HomeColorsCollection.getDescription(indexPath.item))
        
        /// calculate cell size
        let cellSize = self.cellSize(cell)
        
        /// cache the cell size for the next time
        viewModel.setSize(for: indexPath, size: cellSize)

             /// return the cached size
        return viewModel.getSize(for: indexPath)?.height ?? 50
    }
    
    private func cellSize(_ cell: HomeCollectionViewCell) -> CGSize {
        
        let cellWidth = (collectionView.frame.width -
                            (collectionView.contentInset.left + collectionView.contentInset.right + 8)) / 2
        let cellHeight = cell.calculateHeight()
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: Injectable
extension HomeViewController: Injectable {
    
    typealias Payload = HomeViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
