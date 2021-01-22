//
//  SubCategoriesViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 21/01/2021.
//

import UIKit
import RxSwift

final class SubCategoriesViewController: BaseViewController {

    /// UI Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    /// Refresh control
    private let refreshControl = UIRefreshControl()
    
    /// Properties
    private(set) var viewModel: SubCategoriesViewModel!
        
    /// RxSwift
    private let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        bindObservables()
        configureViews()
        viewModel.fetchSubCategories()
    }
    
    private func styleNavigationItem() {
        navigationItemStyle = NavigationItemStyle.searchPlaceHolderStyle(self, #selector(searchPlaceholderTapped))
    }
    
    private func configureViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        let nib = UINib(nibName: SubCategoryTableViewCell.identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: SubCategoryTableViewCell.identifier)
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
                self.tableView.reloadData()
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
    
    @objc
    private func searchPlaceholderTapped() {
        (coordinator as? CategoriesCoordinator)?.startSearch()
    }
}

// MARK: UICollectionViewDelegate
extension SubCategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /// check if we should fetch the next page
        if viewModel.shouldGetNextPage(withCellIndex: indexPath.row) {
            viewModel.getNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let category = viewModel.item(at: indexPath) else {
            return
        }
        debugPrint("did select subCategory \(category.name)")
    }
}
 
// MARK: UICollectionViewDataSource
extension SubCategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoryTableViewCell.identifier,
                                                            for: indexPath) as? SubCategoryTableViewCell else {
            
            fatalError("Couldn't dequeue a cell! \(SubCategoryTableViewCell.description())")
        }

        cell.configure(with: viewModel.item(at: indexPath))
        return cell
    }
}

// MARK: Injectable
extension SubCategoriesViewController: Injectable {
    
    typealias Payload = SubCategoriesViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}

