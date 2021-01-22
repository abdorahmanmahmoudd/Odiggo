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
        let backButton = UIBarButtonItem.odiggoBackButton(target: self,
                                                          action: #selector(self.didPressBackButton),
                                                          tintColor: UIColor.color(color: .denim))
        
        let searchPlaceholder = UIBarButtonItem.searchPlaceholderItem(target: self,
                                                                      action: #selector(searchPlaceholderTapped))
        navigationItemStyle = NavigationItemStyle.searchPlaceHolderStyle(items: [backButton, searchPlaceholder].compactMap({ $0 }))
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55))
        
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 0, width: headerView.frame.width - 16, height: headerView.frame.height)
        label.text = viewModel.sectionTitle()
        label.font = UIFont.font(.primaryBold, .huge)
        label.textColor = UIColor.color(color: .greyishBrown)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
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

