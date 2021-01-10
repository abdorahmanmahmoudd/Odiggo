//
//  OTextField.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit

final class OTextField: UITextField {

    private let box: UIView = UIView()
    private let accessoryButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
    private let textInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 38)
    var hideClearButton: Bool = true
    
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1 : 0.5
        }
    }

    var textfieldType: OTextFieldType = .username {
        didSet {
            updateForType()
        }
    }
    
    var isActive: Bool = true {
        didSet {
            updateForActive()
        }
    }
    
    var showBoxedError: Bool? {
        didSet {
            guard isActive == false else {
                return
            }
            
            let pinkishColor = UIColor.color(color: .pinkishRed).withAlphaComponent(0.16)
            
            box.backgroundColor = showBoxedError == true ? pinkishColor : UIColor.clear
            box.layer.borderColor = showBoxedError == true ? pinkishColor.cgColor : textfieldType.inactiveBorderColor
        }
    }
    
    var showBoxedHint: Bool? {
        didSet {
            
            let pinkishColor = UIColor.color(color: .pinkishRed).withAlphaComponent(0.16)
            
            box.backgroundColor = showBoxedHint == true ? pinkishColor : UIColor.clear
            box.layer.borderColor = showBoxedHint == true ? pinkishColor.cgColor : textfieldType.inactiveBorderColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 30, y: 0, width: 30, height: bounds.height)
    }
    
    @objc func clearView(_ sender: UIButton) {
        switch textfieldType {
        case .disabled:
            return
        case .username, .email:
            text = ""
        case .password:
            sender.isSelected.toggle()
            toggleSecureEntry()
        }
    }
    
    // MARK: Setup
    func setupView() {
        
        backgroundColor = UIColor.color(color: .warmGreyTwo)
        clipsToBounds = false
        layer.cornerRadius = 22
        tintColor = UIColor.color(color: .pinkishRed)
        font = UIFont.font(.primaryRegular, .medium)
        textColor = .color(color: .warmGreyTwo)
        returnKeyType = .next
        
        box.isUserInteractionEnabled = false
        box.layer.borderWidth = 0
        box.layer.cornerRadius = 22
        
        addSubview(box)
        box.activateConstraints(for: self)
        
        updateForActive()
        addAccessoryButton()
    }
}

// MARK: Helper methods
extension OTextField {
    
    func addAccessoryButton() {
        accessoryButton.isSelected = false
        isSecureTextEntry = textfieldType == .password
        
        accessoryButton.setImage(textfieldType.image, for: .normal)
        accessoryButton.setImage(textfieldType.selectedImage, for: .selected)
        accessoryButton.contentMode = .center
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        indentView.addSubview(accessoryButton)
        accessoryButton.translatesAutoresizingMaskIntoConstraints = false
        accessoryButton.widthAnchor.constraint(lessThanOrEqualToConstant: indentView.bounds.width).isActive = true
        accessoryButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        accessoryButton.centerYAnchor.constraint(equalTo: indentView.centerYAnchor).isActive = true
        accessoryButton.centerXAnchor.constraint(equalTo: indentView.centerXAnchor, constant: -8).isActive = true
        
        rightView = indentView
        accessoryButton.addTarget(self, action: #selector(clearView(_:)), for: .touchUpInside)
        
        rightViewMode = .always
        clearButtonMode = .never
        
        accessoryButton.isHidden = false
    }
    
    private func updateForType() {

        accessoryButton.setImage(textfieldType.image, for: .normal)
        accessoryButton.setImage(textfieldType.selectedImage, for: .selected)
        
        backgroundColor = UIColor.color(color: .white)
        box.layer.borderColor = textfieldType.inactiveBorderColor
        isEnabled = true
        
        textColor = UIColor.color(color: .warmGreyTwo)
        clearsOnBeginEditing = false
        isUserInteractionEnabled = true
        autocorrectionType = .no
        inputAssistantItem.leadingBarButtonGroups.removeAll()
        inputAssistantItem.trailingBarButtonGroups.removeAll()
        autocapitalizationType = .none
        
        switch textfieldType {
        case .username:
            keyboardType = .emailAddress
            textContentType = .username
            box.layer.borderWidth = 1
            
        case .email:
            keyboardType = .emailAddress
            textContentType = .emailAddress
            box.layer.borderWidth = 1
            
        case .password:
            keyboardType = .asciiCapable
            textContentType = .password
            box.layer.borderWidth = 1
            
        case .disabled:
            box.layer.borderColor = UIColor.color(color: .poleRose).withAlphaComponent(0.2).cgColor
            box.layer.borderWidth = 2
            backgroundColor = UIColor.clear
            isUserInteractionEnabled = false
            textColor = UIColor.color(color: .poleRose).withAlphaComponent(0.2)
        }
        
        accessoryButton.isSelected = false
        isSecureTextEntry = textfieldType == .password
    }
    
    private func updateForActive() {
        
        guard showBoxedHint != true else { return }
        
        if hideClearButton == false {
            accessoryButton.isHidden = !isActive
        }
        
        if isActive == false && showBoxedError == true {
            box.backgroundColor = UIColor.color(color: .white).withAlphaComponent(0.16)
            box.layer.borderColor = UIColor.color(color: .pinkishRed).cgColor
            
        } else if isActive == false {
            box.backgroundColor = UIColor.color(color: .white).withAlphaComponent(0.16)
            box.layer.borderColor = textfieldType.inactiveBorderColor
            
        } else {
            box.backgroundColor = UIColor.color(color: .white)
            box.layer.borderColor = textfieldType.activeBorderColor
        }
    }
    
    func setPlaceHolder(text: String, characterSpacing: Int = 0) {
        
        attributedPlaceholder = NSAttributedString(string: text,
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.color(color: .warmGreyTwo),
                                                                NSAttributedString.Key.font: UIFont.font(.primaryRegular, .medium),
                                                                NSAttributedString.Key.kern: characterSpacing])
    }
}
