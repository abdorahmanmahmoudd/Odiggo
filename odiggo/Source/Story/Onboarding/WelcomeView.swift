//
//  WelcomeView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 02/01/2021.
//

import UIKit

final class WelcomeView: UIView {

    // UI Outlets
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var getStartedButton: OButton!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    /// Set this closure to handle the button click
    var getStartedTapped: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Style subviews
        styleViews()
    }
    
    private func styleViews() {
        subtitleLabel.font = .font(.primaryMedium, .medium)
        getStartedButton.titleLabel?.font = .font(.primaryBold, .medium)
        
        getStartedButton.config(title: "GET_STARTED_BUTTON_TITLE".localized, image: nil,
                                type: .primary, font: .font(.primaryBold, .medium),
                                alignment: .textLeading, state: .normal)
    }
    
    func configure(withSubtitle subtitle: String?, coverImage: String) {
        subtitleLabel.text = subtitle
        coverImageView.image = UIImage(named: coverImage)
    }

    @IBAction private func getStartedTapped(_ sender: UIButton) {
        getStartedTapped?()
    }
}
