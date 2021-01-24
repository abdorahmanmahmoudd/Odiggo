//
//  IntrinsicSizeTableView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 24/01/2021.
//

import UIKit

class IntrinsicSizeTableView: UITableView {
    
    override var contentSize: CGSize{
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        return CGSize.init(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
