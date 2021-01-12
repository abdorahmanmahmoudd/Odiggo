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
    private var type: ButtonStyle?
    var status: ButtonStates = ButtonStates.normal {
        didSet {
            guard let type = self.type else { return }
            configureState(status, forType: type)
        }
    }

    func config(title: String? = nil, image: UIImage? = nil, type: ButtonStyle, font: UIFont,
                alignment: ContentAlignment = .textLeading, state: ButtonStates = .normal) {
        
        self.type = type
        setTitle(title, for: .normal)
        titleLabel?.font = font

        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit

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
        
        configureState(state, forType: type)
    }
    
    private func configureState(_ state: ButtonStates, forType type: ButtonStyle) {
        setTitleColor(type.titleColor(state: state), for: .normal)
        tintColor = type.titleColor(state: state)
        backgroundColor = type.backgroundColor(state: state)
        isEnabled = state != .disabled
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
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: horizontalEdgeInset)
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
