//
//  ProductDetailsViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 28/01/2021.
//

import UIKit

final class ProductDetailsViewController: BaseViewController {

    /// UI Outlets
    @IBOutlet weak var pageControlView: PageControl!
    @IBOutlet private(set) weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var productDetailsContainerView: UIView!
    @IBOutlet private weak var orderNowButton: OButton!
    
    /// UI Constraints
    @IBOutlet private(set) var pageControlViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) var imageContainerHeightConstraint: NSLayoutConstraint!
    
    /// Pan gesture variables, public so we can use it in an extension
    lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    var isPanGesturing: Bool = false
    var currentSnapPosition: SnapPosition = .top
    var startConstant: CGFloat = 0
    var startTranslation: CGPoint = .zero
    lazy var defaultNavigationBarHeight: CGFloat = navigationController?.navigationBar.bounds.height ?? 0
    lazy var tabbarHeight: CGFloat = tabBarController?.tabBar.bounds.height ?? 0
    
    /// Properties
    private(set) var viewModel: ProductDetailsViewModel!
    private(set) weak var productDetailsView: ProductDetailsView!
    
    let minImagesContainerViewHeightPercentage: CGFloat = 0.252
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNavigationItem()
        bindObservables()
        configureViews()
        viewModel.fetchProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = !isMovingFromParent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = isMovingFromParent
    }
    
    private func styleNavigationItem() {
        let backButton = UIBarButtonItem.odiggoBackButton(target: self,
                                                          action: #selector(self.didPressBackButton),
                                                          tintColor: UIColor.color(color: .denim))
        
        let cartButton = UIBarButtonItem.customBarButtonItem(image: UIImage(named: "product.cart.icon"),
                                                             selector: nil,
                                                             target: nil)
        
        let shareButton = UIBarButtonItem.customBarButtonItem(image: UIImage(named: "product.share.icon"),
                                                              selector: #selector(self.share(sender:)),
                                                              target: self)
        
        navigationItemStyle = NavigationItemStyle.detailsStyle(leftItems: [backButton].compactMap({ $0 }),
                                                               rightItems: [cartButton, shareButton].compactMap({ $0 }))
    }
    
    private func configureViews() {
        configureImagesCollectionView()
        embedProductDetailsView()
        configurePanGesture()
        pageControlView.addTarget(self, action: #selector(onPageChanged(_:)), for: .valueChanged)
        pageControlView.hightlightedDotSelection = false
        orderNowButton.config(title: "ORDER_NOW_TITLE".localized, image: UIImage(named: "cart.icon"),
                              type: .primary(backgroundColor: .mediumGreen), font: UIFont.font(.primaryBold, .huge),
                              alignment: .textTrailing)
    }
    
    private func configureImagesCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        if let flowLayout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        let nib = UINib(nibName: ProductImageCollectionViewCell.identifier, bundle: Bundle.main)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: ProductImageCollectionViewCell.identifier)
    }
    
    private func embedProductDetailsView() {
        guard let pdv = ProductDetailsView().loadNib() as? ProductDetailsView else {
            fatalError("Couldn't find ProductDetailsView")
        }
        productDetailsContainerView.addSubview(pdv)
        pdv.activateConstraints(for: productDetailsContainerView)
        pdv.scrollView.isScrollEnabled = false
        productDetailsView = pdv
        productDetailsView.configure(with: viewModel.productDetails())
    }
    
    private func bindObservables() {
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            switch self.viewModel.state {
            
            case .initial, .refreshing:
                debugPrint("initial & refreshing ProductDetailsViewController")
                
            case .loading:
                debugPrint("loading ProductDetailsViewController")
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result ProductDetailsViewController")
                self.showLoadingIndicator(visible: false)
                self.setPages(self.viewModel.numberOfImages())
                self.imagesCollectionView.reloadData()
            }
        }
    }
    
    override func retry() {
        viewModel.fetchProduct()
    }
    
    // MARK: - Pan Gesture recognizer Related
    func configurePanGesture() {
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
         
        /// Only apply our logic to our pan gesture
        guard gestureRecognizer == panGesture else {
            return true
        }
        
        /// Find the visible scrollview from the `ProductDetailsView`
        guard let visibleScrollView = productDetailsView.scrollView else {
            return false
        }
        
        /// Don't scroll on 3D touch
        guard presentedViewController == nil else {
            return false
        }
        
        let velocity = panGesture.velocity(in: view)
        let locationInView = panGesture.location(in: view)
        let isScrollingVertical = abs(velocity.y) > abs(velocity.x)

        /// If we're touching the header view, we should start scrolling
        if visibleScrollView.contentOffset.y > 0 && currentSnapPosition == .bottom {
            let touchHeight: CGFloat = defaultNavigationBarHeight
            return locationInView.y < touchHeight && isScrollingVertical
        }
        
        /// Check if we're touching the details scrollview
        if currentSnapPosition == .top,
            productDetailsView.frame.contains(locationInView) == true {
            
            if visibleScrollView.contentOffset.y == 0 && velocity.y > 0 {
                /// The scrollView is scrolled to top and the user is scrolling the detail page view up (it will start bouncing)
                visibleScrollView.bounces = false
                return isScrollingVertical
                
            } else if visibleScrollView.contentOffset.y.rounded() >= visibleScrollView.contentSize.height && velocity.y < 0 {
                /// The ScrollView is scrolled down and the user is scrolling the detail page view down
                visibleScrollView.bounces = false
                return isScrollingVertical
                
            } else {
                /// The scroll view is scrolling, we shouldn't start the detail page view scroll
                visibleScrollView.bounces = true
                return false
            }
        }
        
        /// Don't scroll the view when we're scrolling another scrollView (i.e. collection view of episodes)
        if visibleScrollView.contentOffset.y <= 0 && velocity.y >= 0 {
            
            /// We are scrolling up and the visible scrollView is scrolled to top from the bottom view controllers
            toggleBounces(visibleScrollView: visibleScrollView, isScrollingUp: true)
            return isScrollingVertical
            
        } else {
            /// We are scrolling down, only start the gesture if the snap position is currently on top
            toggleBounces(visibleScrollView: visibleScrollView, isScrollingUp: false)
            return currentSnapPosition == .top && isScrollingVertical
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        /// Only apply our logic to our pan gesture
        guard gestureRecognizer == panGesture else {
            return false
        }
        
        /// Find the visible scrollview from the `ProductDetailsView`
        guard let visibleScrollView = productDetailsView.scrollView else {
            return false
        }
        
        let locationInView = panGesture.location(in: view)
        
        /// Check if we're touching the episode scrollview
        if currentSnapPosition == .top,
           productDetailsView.frame.contains(locationInView) == true {
            
            return visibleScrollView.contentOffset.y == 0 || visibleScrollView.contentOffset.y.rounded() >= visibleScrollView.contentSize.height
        }
        
        /// When the scroll view is scrolled to top or futher, we should scroll too
        return visibleScrollView.contentOffset.y <= 0
    }
    
    // MARK: - Actions
    @IBAction func OrderNowTapped(_ sender: OButton) {
        debugPrint("OrderNowTapped")
    }
    
    @IBAction func whatsAppUsTapped(_ sender: Any) {
        debugPrint("whatsAppUsTapped")
    }
    
    @objc
    func share(sender: UIView){

        let textToShare = "CHECK_OUT_THIS_ONE".localized
        guard let myWebsite = URL(string: viewModel.linkToShare()) else {
            return
        }
        let image = UIImage(named: "home.logo") ?? UIImage()
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [textToShare, myWebsite, image], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]

        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let image = viewModel.image(for: indexPath) else {
            return
        }
        debugPrint("didSelectItemAt \(image)")
    }
}
 
// MARK: UICollectionViewDataSource
extension ProductDetailsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.identifier,
                                                            for: indexPath) as? ProductImageCollectionViewCell else {
            
            fatalError("Couldn't dequeue a cell! \(ProductImageCollectionViewCell.description())")
        }
        cell.configure(with: viewModel.image(for: indexPath))
        return cell
    }
}

// MARK: PageControl
extension ProductDetailsViewController: UIScrollViewDelegate {
    
    func setPages(_ pages: Int) {
        pageControlView.numberOfPages = pages
        setCurrentPage(0)
    }
    
    func setCurrentPage(_ page: Int) {
        pageControlView.currentPage = page
    }
    
    @objc func onPageChanged(_ sender: PageControl) {
        debugPrint("page change to \(sender.currentPage)")
    }
    
    /// Updating the PageControl current page
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let slideWidth = Float(view.frame.width)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        
        /// to determine wether we are scrolling to the next or the previous item
        if targetOffset > currentOffset {
            /// next item offset
            newTargetOffset = ceilf(currentOffset / slideWidth) * slideWidth
            
        } else {
            /// previous item offset
            newTargetOffset = floorf(currentOffset / slideWidth) * slideWidth
        }
        
        /// to handle scroll before first item
        if newTargetOffset < 0 {
            newTargetOffset = 0
            
        } else if newTargetOffset > Float(scrollView.contentSize.width) { /// to handle scroll after last item
            newTargetOffset = Float(scrollView.contentSize.width)
        }
        
        /// calculate new target index
        let newTargetIndex = Int(newTargetOffset / slideWidth)
        
        /// Update page control with the new index
        setCurrentPage(newTargetIndex)
    }
}

// MARK: - Injectable
extension ProductDetailsViewController: Injectable {
    
    typealias Payload = ProductDetailsViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }
    
    func assertInjection() {
        assert(viewModel != nil)
    }
}
