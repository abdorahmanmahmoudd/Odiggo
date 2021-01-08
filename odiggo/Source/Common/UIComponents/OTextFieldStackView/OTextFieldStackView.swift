//
//  OTextFieldStackView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit

protocol OTextFieldStackViewDelegate: AnyObject {
    func errorButtonTapped()
}

@IBDesignable
final class OTextFieldStackView: UIStackView {
    
    enum AccessoryType {
        case forgotPassword
        case none
    }
    
    // MARK: inspectables
    @IBInspectable var textfieldOrder: Int = 0 {
        didSet {
            textField.tag = textfieldOrder
        }
    }
    
    @IBInspectable var textfieldType: Int = 2 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var lastTextfield: Bool = false {
        didSet {
            textField.returnKeyType = lastTextfield ? .go : .next
        }
    }
    
    // MARK: Properties
    let textField: OTextField = OTextField()
    private let title: UILabel = UILabel()
    private let accessoryButton: UIButton = UIButton(type: .custom)
    weak var delegate: OTextFieldStackViewDelegate?
    
    weak var textfieldDelegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = textfieldDelegate
        }
    }
    
    var titleText: String? {
        didSet {
            updateTitle()
        }
    }
    
    var attributedAccessoryText: NSAttributedString? {
        didSet {
            updateAccessoryLabel()
        }
    }
    
    var errorType: AccessoryType = .none {
        didSet {
            accessoryButton.isEnabled = errorType != .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        updateTitle()
        updateView()
        updateAccessoryLabel()
        title.font = UIFont.font(.primaryBold, .little)
        title.textColor = UIColor.color(color: .warmGrey)
        
        self.layoutIfNeeded()
        axis = .vertical
        distribution = .fillProportionally
        spacing = 10
        
        setupAccessoryButton()
        setupConstraints()
    }
    
    func setupAccessoryButton() {
        accessoryButton.setImage(UIImage(named: "error-icon"), for: .normal)
        accessoryButton.titleLabel?.numberOfLines = 0
        
        accessoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        accessoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        accessoryButton.addTarget(self, action: #selector(errorTapped(_:)), for: .touchUpInside)
        accessoryButton.contentHorizontalAlignment = .left
        
        accessoryButton.adjustsImageWhenDisabled = false
        accessoryButton.adjustsImageWhenHighlighted = false
        
        accessoryButton.isEnabled = false
        accessoryButton.isHidden = true
    }
    
    func setupConstraints() {
        addArrangedSubview(title)
        addArrangedSubview(textField)
        addArrangedSubview(accessoryButton)
        
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        title.heightAnchor.constraint(equalToConstant: 19).isActive = true
        accessoryButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    // MARK: updates
    private func updateTitle() {
        title.text = titleText
        title.isHidden = titleText == nil
    }
    
    private func updateAccessoryLabel() {
        accessoryButton.setAttributedTitle(attributedAccessoryText, for: .normal)
    }
    
    private func updateView() {
        if let type = OTextFieldType(rawValue: textfieldType) {
            textField.textfieldType = type
        }
    }
    
}

// MARK: Helper methods
extension OTextFieldStackView {
    
    func showError(_ showError: Bool) {
        accessoryButton.setImage(UIImage(named: "error-icon"), for: .normal)
        textField.showBoxedError = showError
        
        if attributedAccessoryText != nil && showError == true && textField.isActive == false {
            accessoryButton.isHidden = false
        } else {
            accessoryButton.isHidden = true
        }
    }
    
    @objc func errorTapped(_ sender: UIButton) {
        
        switch errorType {
        case .forgotPassword:
            delegate?.errorButtonTapped()
            
        case .none:
            break
        }
    }
}

