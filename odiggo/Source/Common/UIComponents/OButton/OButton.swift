//
//  OButton.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 04/01/2021.
//

import UIKit

final class OButton: UIButton {
    
    private let horizontalEdgeInset: CGFloat = 16.0
    private let verticalPadding: CGFloat = 8.0
    private let cornerRadius: CGFloat = 25.0

    func config(title: String? = nil, image: UIImage? = nil, type: ButtonStyle, font: UIFont,
                alignment: ContentAlignment = .textLeading, state: ButtonStates = .normal) {
        
        setTitle(title, for: .normal)
        setTitleColor(type.titleColor(state: state), for: .normal)
        titleLabel?.font = font

        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit

        tintColor = type.titleColor(state: state)
        backgroundColor = type.backgroundColor(state: state)

        switch alignment {
        case .textLeading:
            semanticContentAttribute = .forceRightToLeft
        case .textTrailing, .none:
            semanticContentAttribute = .forceLeftToRight
        }

        layer.cornerRadius = cornerRadius
        layer.borderWidth = type.borderWidth()
        layer.borderColor = type.borderColor()

        setInsets(alignment: alignment, image: image, type: type)
    }

    private func setInsets(alignment: ContentAlignment, image: UIImage?, type: ButtonStyle) {

        var edgeInsets = UIEdgeInsets(top: verticalPadding, left: horizontalEdgeInset,
                                      bottom: verticalPadding, right: horizontalEdgeInset)

        /// If there is a image, we need custom constraints within the button
        if image != nil {
            /// Set the spacing between the label and imageView
            /// The functions returns depending on the alignment, so can return 0 if the image is not on the left or right side
            edgeInsets.left += alignment.imageLeftPadding()
            edgeInsets.right += alignment.imageRightPadding()
        }

        switch type {
        case .text:
            edgeInsets.left = 0
            edgeInsets.right = -6.0
        default:
            break
        }

        contentEdgeInsets = edgeInsets
    }
}
