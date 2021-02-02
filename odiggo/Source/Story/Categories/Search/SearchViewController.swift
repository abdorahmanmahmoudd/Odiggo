//
//  SearchViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 23/01/2021.
//

import UIKit
import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {
    
    @IBOutlet private weak var noResultViewContainer: UIView!
    @IBOutlet private weak var searchHistoryTitleLabel: UILabel!
    @IBOutlet private weak var keywordsTitleLabel: UILabel!
    @IBOutlet private weak var alignedCollectionViewLayout: AlignedCollectionViewFlowLayout!
    @IBOutlet private weak var searchHistoryTableView: IntrinsicSizeTableView!
    @IBOutlet private weak var keywordsCollectionView: IntrinsicSizeCollectionView!
    
    /// Properties
    private var viewModel: SearchViewModel!
    private var searchTextField: OTextField?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        bindObservables()
        configureViews()
        viewModel.fetchSearchHistory()
    }
    
    private func styleNavigationItem() {
        let backButton = UIBarButtonItem.odiggoBackButton(target: self,
                                                          action: #selector(self.didPressBackButton),
                                                          tintColor: UIColor.color(color: .denim))
        
        let searchItem = UIBarButtonItem.searchItem(delegate: self)
        searchTextField = searchItem.customView as? OTextField
        navigationItemStyle = NavigationItemStyle.searchPlaceHolderStyle(items: [backButton,
                                                                                 searchItem].compactMap({ $0 }))
    }
    
    private func configureViews() {
        
        configureKeywordsCollectionView()
        configureSearchHistoryTableView()
        configureResultEmptyView()
        
        keywordsTitleLabel.text = "KEYWORDS_TITLE".localized
        searchHistoryTitleLabel.text = "SEARCHHISTORY_TITLE".localized
        keywordsTitleLabel.font = UIFont.font(.primaryBold, .huge)
        searchHistoryTitleLabel.font = UIFont.font(.primaryBold, .huge)
    }
    
    private func configureKeywordsCollectionView() {
        keywordsCollectionView.delegate = self
        keywordsCollectionView.dataSource = self
        
        let nib = UINib(nibName: KeywordCollectionViewCell.identifier, bundle: Bundle.main)
        keywordsCollectionView.register(nib, forCellWithReuseIdentifier: KeywordCollectionViewCell.identifier)
        
        alignedCollectionViewLayout.minimumLineSpacing = 15
        alignedCollectionViewLayout.minimumInteritemSpacing = 10
        alignedCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        alignedCollectionViewLayout.horizontalAlignment = .left
    }
    
    private func configureSearchHistoryTableView() {
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.rowHeight = 40
        
        let nib = UINib(nibName: SearchHistoryTableViewCell.identifier, bundle: Bundle.main)
        searchHistoryTableView.register(nib, forCellReuseIdentifier: SearchHistoryTableViewCell.identifier)
    }
    
    private func bindObservables() {
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            switch self.viewModel.state {
            
            case .initial, .refreshing:
                debugPrint("initial & refreshing SearchViewController")
                
            case .loading:
                debugPrint("loading SearchViewController")
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result SearchViewController")
                self.showLoadingIndicator(visible: false)
                
                self.noResultViewContainer.isHidden = !self.viewModel.isEmpty()
                self.keywordsCollectionView.reloadData()
                self.searchHistoryTableView.reloadData()
            }
        }
        
        /// Bind TexttField value changed event
        searchTextField?.rx.controlEvent([.editingChanged])
            .observeOn(MainScheduler.instance).asObservable()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                
                if let text = self?.searchTextField?.text, text.hasContent() {
                    self?.viewModel.fetchKeywords(text)
                }
                
            }).disposed(by: disposeBag)
    }
    
    override func retry() {
        viewModel.fetchKeywords()
    }
    
    override func viewTapped(_ sender: UITapGestureRecognizer) {
        super.viewTapped(sender)
        searchTextField?.resignFirstResponder()
    }
    
    private func configureResultEmptyView() {
        
        guard let emptyView = ResultEmptyView().loadNib() as? ResultEmptyView else {
            return
        }
        emptyView.configure(with: "search.empty.icon",
                            title: "NO_RESULT_TITLE".localized,
                            description: "NO_RESULT_DESC".localized)
        noResultViewContainer.addSubview(emptyView)
        emptyView.activateConstraints(for: noResultViewContainer)
        noResultViewContainer.isHidden = true
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            viewModel.fetchKeywords(text)
        }
        return true
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let keyword = viewModel.keyword(for: indexPath) else {
            return
        }
        debugPrint("didSelectItemAt \(keyword)")
        (coordinator as? CategoriesCoordinator)?.startSearchResult(with: keyword)
    }
}
 
// MARK: UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfKeywords()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.identifier,
                                                            for: indexPath) as? KeywordCollectionViewCell else {
            
            fatalError("Couldn't dequeue a cell! \(KeywordCollectionViewCell.description())")
        }
        cell.configure(viewModel.keyword(for: indexPath))
        return cell
    }
}

// MARK: UICollectionViewFlowlayoutDelegate
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let keyword = viewModel.keyword(for: indexPath) else {
            return CGSize.zero
        }
        let font = UIFont.font(.primarySemiBold, .medium)
        let width = keyword.width(withConstrainedHeight: 45, font: font) + 32
        
        return CGSize(width: width, height: 45)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSearchHistoryRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTableViewCell.identifier,
                                                            for: indexPath) as? SearchHistoryTableViewCell else {
            
            fatalError("Couldn't dequeue a cell! \(SubCategoryTableViewCell.description())")
        }

        cell.configure(viewModel.searchHistory(for: indexPath), and: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let searchItem = viewModel.searchHistory(for: indexPath) else {
            return
        }
        searchTextField?.text = searchItem
        viewModel.fetchKeywords(searchItem)
    }
}

// MARK: SearchHistoryCellDelegate {
extension SearchViewController: SearchHistoryCellDelegate {
    
    func deleteButtonTapped(for indexPath: IndexPath) {
        viewModel.removeSearchItem(for: indexPath)
    }
}

// MARK: - Injectable
extension SearchViewController: Injectable {
    
    typealias Payload = SearchViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
