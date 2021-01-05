//
//  GetStartedView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 02/01/2021.
//

import UIKit

final class GetStartedView: UIView {

    // UI Outlets
    @IBOutlet private weak var pageControlView: OPageControlView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var getStartedButton: OButton!
    
    /// Set this closure to handle the button click
    var getStartedTapped: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViews()
    }
    
    private func styleViews() {
        titleLabel.font = .font(.primaryBold, .gigantic)
        subtitleLabel.font = .font(.primaryMedium, .medium)
        
        getStartedButton.titleLabel?.font = .font(.primaryBold, .medium)
        getStartedButton.config(title: "GET_STARTED_BUTTON_TITLE".localized, image: nil,
                          type: .primary, font: .font(.primaryBold, .medium),
                          alignment: .textLeading, state: .normal)
    }
    
    func configure(title: String?, subtitle: String?, coverImage: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        coverImageView.image = UIImage(named: coverImage)
    }
    
    func setPages(_ pages: Int) {
        pageControlView.pages = pages
    }
    
    func setCurrentPage(_ page: Int) {
        pageControlView.currentPage = page
    }
    
    @IBAction private func getStartedTapped(_ sender: UIButton) {
        getStartedTapped?()
    }
}
