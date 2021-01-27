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
    enum ButtonStyle: Equatable {
        case primary(backgroundColor: UIColor.Colors? = nil)
        case text(titleColor: UIColor.Colors)
        case outline
        case filteration

        func titleColor(state: ButtonStates) -> UIColor {
            switch self {
            case .primary, .filteration:
                switch state {
                case .normal:
                    return UIColor.white
                case .disabled:
                    return UIColor.color(color: .warmGreyTwo)
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
            case .primary(let color):
                
                switch state {
                case .normal:
                    if let color = color {
                        return UIColor.color(color: color)
                    }
                    return UIColor.color(color: .pinkishRed)
                    
                case .disabled:
                    return UIColor.color(color: .denim).withAlphaComponent(0.16)
                }
                
            case .text, .outline, .filteration:
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
