//
//  ReusableIdentifier.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import Foundation

/// Default identifier added to UIViews
protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension ReusableIdentifier {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
