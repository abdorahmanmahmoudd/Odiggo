//
//  GetStartedView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 02/01/2021.
//

import UIKit

final class GetStartedView: UIView {

    // UI Outlets
    @IBOutlet private weak var pageControlView: PageControl!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var getStartedButton: OButton!
    
    /// Set this closure to handle the button click
    var getStartedTapped: (() -> Void)? = nil
    var pageControlValueChange: ((Int) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViews()
        pageControlView.addTarget(self, action: #selector(onPageChanged(_:)), for: .valueChanged)
    }
    
    private func styleViews() {
        titleLabel.font = .font(.primaryBold, .gigantic)
        subtitleLabel.font = .font(.primaryMedium, .medium)
        
        getStartedButton.config(title: "GET_STARTED_BUTTON_TITLE".localized,
                          type: .primary, font: .font(.primaryBold, .medium))
    }
    
    func configure(title: String?, subtitle: String?, coverImage: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        coverImageView.image = UIImage(named: coverImage)
    }
    
    func setPages(_ pages: Int) {
        pageControlView.numberOfPages = pages
    }
    
    func setCurrentPage(_ page: Int) {
        pageControlView.currentPage = page
    }
    
    @IBAction private func getStartedTapped(_ sender: UIButton) {
        getStartedTapped?()
    }
    
    @objc func onPageChanged(_ sender: PageControl) {
        pageControlValueChange?(sender.currentPage)
    }
}
