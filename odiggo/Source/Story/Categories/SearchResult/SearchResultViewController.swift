//
//  SearchResultViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 25/01/2021.
//

import UIKit

final class SearchResultViewController: BaseViewController {

    @IBOutlet private weak var resultTableView: UITableView!
    
    /// Properties
    private(set) var viewModel: SearchResultViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        bindObservables()
        configureViews()
        viewModel.fetchSearchResult()
    }
    
    private func styleNavigationItem() {
        let backButton = UIBarButtonItem.odiggoBackButton(target: self,
                                                          action: #selector(self.didPressBackButton),
                                                          tintColor: UIColor.color(color: .denim))
        
        navigationItemStyle = NavigationItemStyle.resultStyle(title: "SEARCH_RESULT".localized,
                                                              items: [backButton].compactMap({ $0 }))
    }
    
    private func configureViews() {
        configureSearchResultTableView()
    }
    
    private func configureSearchResultTableView() {
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
            
            switch self.viewModel.state {
            
            case .initial, .refreshing:
                debugPrint("initial & refreshing SearchResultViewController")
                
            case .loading:
                debugPrint("loading SearchResultViewController")
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result SearchResultViewController")
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
        viewModel.fetchSearchResult()
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
}

// MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    
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
extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let product = viewModel.item(for: indexPath) else {
            return
        }
        (coordinator as? CategoriesCoordinator)?.productSelected(product)
        debugPrint("didSelectRowAt \(String(describing: viewModel.item(for: indexPath)?.name))")
    }
}

// MARK: - Injectable
extension SearchResultViewController: Injectable {
    
    typealias Payload = SearchResultViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
