//
//  OButton+Style.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 04/01/2021.
//

import UIKit

extension OButton {

    /// The different premade states
    enum ButtonStates {
        case normal
        case disabled
    }

    /// The different premade styles
    /// with colors depending on the state
    enum ButtonStyle {
        case primary
        case text(titleColor: UIColor.Colors)
        case outline

        func titleColor(state: ButtonStates) -> UIColor {
            switch self {
            case .primary:
                switch state {
                case .normal:
                    return UIColor.white
                case .disabled:
                    return UIColor.color(color: .greyish)
                }
            case .text(let color):
                switch state {
                case .normal:
                    return UIColor.color(color: color)
                case .disabled:
                    return UIColor.color(color: color)
                }
            case .outline:
                switch state {
                case .normal:
                    return UIColor.color(color: .blackTwo)
                case .disabled:
                    return UIColor.color(color: .greyish)
                }
            }
        }

        func backgroundColor(state: ButtonStates) -> UIColor {
            switch self {
            case .primary:
                switch state {
                case .normal:
                    return UIColor.color(color: .pinkishRed)
                case .disabled:
                    return UIColor.color(color: .poleRose)
                }
            case .text:
                switch state {
                case .normal:
                    return UIColor.clear
                case .disabled:
                    return UIColor.color(color: .greyish)
                }
            case .outline:
                switch state {
                case .normal:
                    return UIColor.clear
                case .disabled:
                    return UIColor.color(color: .greyish)
                }
            }
        }

        func borderWidth() -> CGFloat {
            switch self {
            case .outline:
                return 1
            default:
                return 0
            }
        }

        func borderColor() -> CGColor {
            switch self {
            case .outline:
                return UIColor.color(color: .greyish).cgColor
            default:
                return UIColor.clear.cgColor
            }
        }
    }
}
