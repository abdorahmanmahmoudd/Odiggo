//
//  CategoriesViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import UIKit
import RxSwift

final class CategoriesViewController: BaseViewController {
    
    /// UI Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let interSpacing: CGFloat = 15
    let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
    
    /// Refresh control
    private let refreshControl = UIRefreshControl()
    
    /// Properties
    private var viewModel: CategoriesViewModel!
        
    /// RxSwift
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        bindObservables()
        configureViews()
        viewModel.fetchCategories()
    }
    
    private func styleNavigationItem() {
        let searchBtn = UIBarButtonItem.customBarButtonItem(image: UIImage(named: "searchBtn.icon"))
        
        let addYourCarBtn = UIBarButtonItem.customBarButtonItem(image: UIImage(named: "addCar.icon"))
        navigationItemStyle = NavigationItemStyle.homePageStyle(items: [addYourCarBtn, searchBtn])
    }
    
    private func configureViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        
        let nib = UINib(nibName: CategoryCollectionViewCell.identifier, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    
    private func bindObservables() {
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            /// end refreshing anyways
            self.refreshControl.endRefreshing()
            
            switch self.viewModel.state {
            
            case .initial, .refreshing:
                debugPrint("initial & refreshing CategoriesViewController")
                
            case .loading:
                debugPrint("loading CategoriesViewController")
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result CategoriesViewController")
                self.showLoadingIndicator(visible: false)
                self.collectionView.reloadData()
            }
        }
        
        /// Bind Refresh control value changed event to refresh the content
        refreshControl.rx.controlEvent(.valueChanged)
            .asObservable()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.refreshCategories()
            }).disposed(by: disposeBag)
    }
    
    override func retry() {
        viewModel.refreshCategories()
    }
}

// MARK: UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        /// check if we should fetch the next page
        if viewModel.shouldGetNextPage(withCellIndex: indexPath.row) {
            viewModel.getNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let category = viewModel.item(at: indexPath) else {
            return
        }
        (coordinator as? CategoriesCoordinator)?.selectCategory(category)
    }
    
}
 
// MARK: UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,
                                                            for: indexPath) as? CategoryCollectionViewCell else {
            
            fatalError("Couldn't dequeue a cell! \(CategoryCollectionViewCell.description())")
        }

        cell.configure(viewModel.item(at: indexPath))
        return cell
    }
}

// MARK: UICollectionViewFlowlayoutDelegate
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    /// Calculates the cell size
    private func cellSize() -> CGSize {
        
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - interSpacing - (insets.left + insets.right)) / 2.0
        let heightRatio: CGFloat = 1.06
        let cellHeight = cellWidth * heightRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
}

// MARK: Injectable
extension CategoriesViewController: Injectable {
    
    typealias Payload = CategoriesViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
