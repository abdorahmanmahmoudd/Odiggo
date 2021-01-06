//
//  OnboardingView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 02/01/2021.
//

import UIKit

final class OnboardingView: UIView {

    // UI Outlets
    @IBOutlet private weak var skipButton: OButton!
    @IBOutlet private weak var nextButton: OButton!
    @IBOutlet private weak var pageControlView: PageControl!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    /// Set these closures to handle the button click
    var nextTapped: (() -> Void)? = nil
    var skipTapped: (() -> Void)? = nil
    var pageControlValueChange: ((Int) -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViews()
        pageControlView.addTarget(self, action: #selector(onPageChanged(_:)), for: .valueChanged)
    }
    
    private func styleViews() {
        titleLabel.font = .font(.primaryBold, .gigantic)
        subtitleLabel.font = .font(.primaryMedium, .medium)
        
        nextButton.titleLabel?.font = .font(.primaryBold, .medium)
        nextButton.config(title: "NEXT_BUTTON_TITLE".localized, image: nil,
                          type: .primary, font: .font(.primaryBold, .medium),
                          alignment: .textLeading, state: .normal)
        
        skipButton.titleLabel?.font = .font(.primaryBold, .medium)
        skipButton.config(title: "SKIP_BUTTON_TITLE".localized, image: nil,
                          type: .text, font: .font(.primaryMedium, .medium),
                          alignment: .textLeading, state: .normal)
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
    
    @IBAction private func nextButtonTapped(_ sender: UIButton) {
        nextTapped?()
    }
    
    @IBAction private func skipButtonTapped(_ sender: UIButton) {
        skipTapped?()
    }
    
    @objc func onPageChanged(_ sender: PageControl) {
        pageControlValueChange?(sender.currentPage)
    }
}
