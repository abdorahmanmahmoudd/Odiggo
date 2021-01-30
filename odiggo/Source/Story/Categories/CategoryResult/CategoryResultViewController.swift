//
//  CategoryResultViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 27/01/2021.
//

import UIKit

final class CategoryResultViewController: BaseViewController {
    
    @IBOutlet private weak var resultTableView: UITableView!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var subCategoryNameLabel: UILabel!
    
    /// Properties
    private(set) var viewModel: CategoryResultViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNavigationItem()
        bindObservables()
        configureViews()
        viewModel.fetchCategoryProducts()
    }
    
    private func styleNavigationItem() {
        let backButton = UIBarButtonItem.odiggoBackButton(target: self,
                                                          action: #selector(self.didPressBackButton),
                                                          tintColor: UIColor.color(color: .denim))
        
        let filterationButton = OButton()
        filterationButton.addTarget(self, action: #selector(self.filterationButtonTapped), for: .touchUpInside)
        filterationButton.config(image: UIImage(named: "filter.icon.full"),
                                 type: .filteration)
        
        let searchPlaceholderItem = UIBarButtonItem.searchPlaceholderItem(target: self,
                                                                          action: #selector(self.searchPlaceholderTapped),
                                                                          rightViewButton: filterationButton)
        
        navigationItemStyle = NavigationItemStyle.searchPlaceHolderStyle(items: [backButton, searchPlaceholderItem].compactMap({ $0 }))
    }
    
    private func configureViews() {
        configureCategoryResultTableView()
        categoryNameLabel.text = viewModel.categoryName()
        subCategoryNameLabel.text = viewModel.subCategoryName()
    }
    
    private func configureCategoryResultTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.rowHeight = 137
        
        let nib = UINib(nibName: SearchResultTableViewCell.identifier, bundle: Bundle.main)
        resultTableView.register(nib, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    }
    
    private func bindObservables() {
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            self.categoryNameLabel.text = self.viewModel.categoryName()
            self.subCategoryNameLabel.text = self.viewModel.subCategoryName()
            
            switch self.viewModel.state {
            
            case .initial, .refreshing:
                debugPrint("initial & refreshing CategoryResultViewController")
                
            case .loading:
                debugPrint("loading CategoryResultViewController")
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result CategoryResultViewController")
                self.showLoadingIndicator(visible: false)
                self.resultTableView.reloadData()

                if self.viewModel.isEmpty() {
                    self.showEmptyView()
                } else {
                    self.resultTableView.backgroundView = nil
                }
            }
        }
    }
    
    override func retry() {
        viewModel.fetchCategoryProducts()
    }
    
    private func showEmptyView() {
        
        guard let emptyView = ResultEmptyView().loadNib() as? ResultEmptyView else {
            return
        }
        emptyView.configure(with: "search.empty.icon",
                            title: "NO_RESULT_TITLE".localized,
                            description: "NO_RESULT_DESC".localized)
        self.resultTableView.backgroundView = emptyView
    }
    
    @objc
    private func filterationButtonTapped() {
        debugPrint("filterationButtonTapped")
    }
}

// MARK: - UITableViewDataSource
extension CategoryResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numerOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier,
                                                       for: indexPath) as? SearchResultTableViewCell else {
            
            fatalError("Couldn't dequeue a cell! \(SearchResultTableViewCell.description())")
        }
        
        cell.configure(with: viewModel.item(for: indexPath))
        return cell
    }
}

// MARK: UITableViewDelegate
extension CategoryResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let product = viewModel.item(for: indexPath) else {
            return
        }
        debugPrint("didSelectRowAt \(String(describing: viewModel.item(for: indexPath)?.name))")
        (coordinator as? CategoriesCoordinator)?.productSelected(product)
    }
}

// MARK: - Injectable
extension CategoryResultViewController: Injectable {
    
    typealias Payload = CategoryResultViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }
    
    func assertInjection() {
        assert(viewModel != nil)
    }
}

