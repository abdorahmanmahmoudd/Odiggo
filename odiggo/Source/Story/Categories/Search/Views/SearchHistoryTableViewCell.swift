//
//  SearchHistoryTableViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 24/01/2021.
//

import UIKit

protocol SearchHistoryCellDelegate: class {
    func deleteButtonTapped(for indexPath: IndexPath)
}

final class SearchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    private var indexPath: IndexPath?
    weak var delegate: SearchHistoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    private func configureViews() {
        titleLabel.font = UIFont.font(.primarySemiBold, .medium)
    }
    
    func configure(_ title: String?, and indexPath: IndexPath) {
        titleLabel.text = title
        self.indexPath = indexPath
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.deleteButtonTapped(for: indexPath)
    }
}
