//
//  ProductDetailsView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 29/01/2021.
//

import UIKit

final class ProductDetailsView: UIView {

    /// UI Outlets
    /// Static Titles
    @IBOutlet private weak var viewAllRelatedButton: OButton!
    @IBOutlet private weak var viewAllReviewButton: OButton!
    @IBOutlet private weak var relatedProductsTitleLabel: UILabel!
    @IBOutlet private weak var productReviewsTitleLabel: UILabel!
    @IBOutlet private weak var freeReturnsLabel: UILabel!
    @IBOutlet private weak var freeDeliveryLabel: UILabel!
    @IBOutlet private weak var fastDeliveryLabel: UILabel!
    @IBOutlet private weak var categoriesTitleLabel: UILabel!
    @IBOutlet private weak var mpnTitleLabel: UILabel!
    @IBOutlet private weak var availabilityTitleLabel: UILabel!
    @IBOutlet private weak var fromTitleLabel: UILabel!
    @IBOutlet private weak var aboutProductLabel: UILabel!
    /// Configurable per product
    @IBOutlet private weak var relatedProductsCollectionView: UICollectionView!
    @IBOutlet private weak var reviewsCollectionView: UICollectionView!
    @IBOutlet private weak var feedbackCounterLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var mpnLabel: UILabel!
    @IBOutlet private weak var availabilityLabel: UILabel!
    @IBOutlet private weak var fromLabel: UILabel!
    @IBOutlet private weak var productDescriptionTextView: UITextView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productRateLabel: UILabel!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var handleView: UIView!
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    
    /// Constraint
    @IBOutlet private var productDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet private var productDescriptionBottomConstraint: NSLayoutConstraint!
    
    /// Properties
    private var productFeedback: [Feedback] = []
    private var relatedProducts: [Product] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTexts()
        configureViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
                
        /// For Rendering optimization
        /// Only use this when you are not doing any animations within the view componenets, otherwise it will have bad performance implications.        
        containerView.layer.shadow(shadow: .cardShadow)
        handleView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
    }
    
    private func configureTexts() {
        
        fromTitleLabel.text = "FROM_TITLE".localized
        availabilityTitleLabel.text = "AVAILABILITY_TITLE".localized
        mpnTitleLabel.text = "MPN_TITLE".localized
        fastDeliveryLabel.text = "FAST_SHIPPING_TITLE".localized
        freeDeliveryLabel.text = "FREE_DELIVERY_TITLE".localized
        freeReturnsLabel.text = "FREE_RETURNS_TITLE".localized
        categoriesTitleLabel.text = "CATEGORIES_TITLE".localized
        productReviewsTitleLabel.text = "PRODUCT_REVIEWS_TITLE".localized
        relatedProductsTitleLabel.text = "RELATED_PRODUCTS_TITLE".localized
        aboutProductLabel.text = "ABOUT_PRODUCT_TITLE".localized
        
        viewAllRelatedButton.config(title: "VIEW_ALL_TITLE".localized,
                                    image: UIImage(named: "right.arrow.red"),
                                    type: .text(titleColor: .scarlet),
                                    font: UIFont.font(.primarySemiBold, .small),
                                    alignment: .textLeading)
        
        viewAllReviewButton.config(title: "VIEW_ALL_TITLE".localized,
                                    image: UIImage(named: "right.arrow.red"),
                                    type: .text(titleColor: .scarlet),
                                    font: UIFont.font(.primarySemiBold, .small),
                                    alignment: .textLeading)
    }

    
    private func configureViews() {
        
        configureRelatedProductsCollectionView()
        configureReviewCollectionView()
        configureTextView()
    }
    
    private func configureRelatedProductsCollectionView() {
        relatedProductsCollectionView.delegate = self
        relatedProductsCollectionView.dataSource = self
        
        let nib = UINib(nibName: RelatedProductCollectionViewCell.identifier, bundle: Bundle.main)
        relatedProductsCollectionView.register(nib, forCellWithReuseIdentifier: RelatedProductCollectionViewCell.identifier)
    }
    
    private func configureReviewCollectionView() {
        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        
        let nib = UINib(nibName: ProductReviewCollectionViewCell.identifier, bundle: Bundle.main)
        reviewsCollectionView.register(nib, forCellWithReuseIdentifier: ProductReviewCollectionViewCell.identifier)
    }
    
    private func configureTextView() {
        productDescriptionTextView.backgroundColor = .clear
        productDescriptionTextView.contentInset = .zero
        productDescriptionTextView.textContainerInset = .zero
        productDescriptionTextView.textContainer.lineFragmentPadding = 0
        productDescriptionTextView.clipsToBounds = false
        productDescriptionTextView.isEditable = false
        productDescriptionTextView.isScrollEnabled = false
        productDescriptionTextView.text = nil
    }
    
    func configure(with product: Product) {
        
        productNameLabel.text = product.name
        feedbackCounterLabel.text = "(\(product.count_feedback ?? 0))"
        productRateLabel.text = "\(product.average_feedback ?? 0)"
        priceLabel.attributedText = "\(product.sale_price ?? 0)".priceLabeled(.gigantic, .huge)
        mpnLabel.text = product.mpn
        fromLabel.text = product.manufacturer
        availabilityLabel.text = "\(product.stock_quantity ?? 0) " + "IN_STOCK".localized
        
        let categoriesNames = product.categories?.compactMap({ $0.name }).joined(separator: ", ") ?? ""
        categoriesLabel.attributedText = categoriesNames.underlinedText()
        
        if let text = product.description?.htmlToAttributedString {
            productDescriptionTextView.attributedText = text
        } else {
            productDescriptionTopConstraint.constant = 0
            productDescriptionBottomConstraint.constant = 0
        }
        
        productFeedback = product.feedbacks ?? []
        reviewsCollectionView.reloadData()
        
        relatedProducts = product.related ?? []
        relatedProductsCollectionView.reloadData()
    }
    
    @IBAction func viewAllRelatedProductsTapped(_ sender: UIButton) {
        debugPrint("viewAllRelatedProductsTapped")
    }
    
    @IBAction func viewAllReviewsTapped(_ sender: UIButton) {
        debugPrint("viewAllReviewsTapped")
    }
    
    @IBAction func copyMPNButtonTapped(_ sender: UIButton) {
        if let text = mpnLabel.text, text.hasContent() {
            UIPasteboard.general.string = text
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductDetailsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("didSelectItemAt \(indexPath)")
    }
}
 
// MARK: UICollectionViewDataSource
extension ProductDetailsView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == reviewsCollectionView {
            return productFeedback.count
            
        } else if collectionView == relatedProductsCollectionView {
            return relatedProducts.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if collectionView == reviewsCollectionView {
            
            guard let reviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductReviewCollectionViewCell.identifier,
                                                                for: indexPath) as? ProductReviewCollectionViewCell else {
                
                fatalError("Couldn't dequeue a cell! \(ProductReviewCollectionViewCell.description())")
            }
            reviewCell.configure(productFeedback[safe: indexPath.item])
            cell = reviewCell
            
        } else if collectionView == relatedProductsCollectionView {
            
            guard let relatedProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedProductCollectionViewCell.identifier,
                                                                for: indexPath) as? RelatedProductCollectionViewCell else {
                
                fatalError("Couldn't dequeue a cell! \(RelatedProductCollectionViewCell.description())")
            }
            relatedProductCell.configure(relatedProducts[safe: indexPath.item])
            cell = relatedProductCell
        }
        
        return cell
    }
}

// MARK: UICollectionViewFlowlayoutDelegate
extension ProductDetailsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == reviewsCollectionView {
            return CGSize(width: UIScreen.main.bounds.width * 0.413, height: 85)
            
        } else if collectionView == relatedProductsCollectionView {
            return CGSize(width: UIScreen.main.bounds.width * 0.306, height: 140)
        }
        
        return CGSize.zero
    }
}
