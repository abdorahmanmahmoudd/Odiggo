//
//  OButton+ContentAlignment.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 04/01/2021.
//

import UIKit

extension OButton {

    /// This enum is for deciding the positioning of horizontal order of the Icon and the Text
    enum ContentAlignment {
        case textLeading
        case textTrailing
        case none

        func imageLeftPadding() -> CGFloat {
            if self == .textTrailing {
                return -6.0
            } else if self == .textLeading {
                return 8.0
            }
            return 0.0
        }

        func imageRightPadding() -> CGFloat {
            if self == .textLeading {
                return -6.0
            } else if self == .textTrailing {
                return 8.0
            }
            return 0.0
        }
    }
}
