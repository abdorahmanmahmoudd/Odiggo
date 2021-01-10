//
//  ForgetPasswordViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 10/01/2021.
//

import UIKit
import RxSwift

final class ForgetPasswordViewController: BaseViewController {
    
    /// UI Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var emailStackView: OTextFieldStackView!
    @IBOutlet private weak var actionButton: OButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var resetConfirmationLabel: UILabel!
    
    /// RxSwift
    let disposeBag = DisposeBag()
    
    private var viewModel: ForgetPasswordViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        bindObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addBackButtonIfNeeded()
    }
    
    private func configureViews() {
        
        configureTexts()
        
        emailStackView.textfieldType = .email
        emailStackView.delegate = self
        emailStackView.lastTextfield = true
        emailStackView.textfieldDelegate = self
        emailStackView.isHidden = false
        
        resetConfirmationLabel.isHidden = true
        
        titleLabel.font = .font(.primaryBold, .huge)
        subtitleLabel.font = .font(.primaryRegular, .medium)
        resetConfirmationLabel.font = .font(.primaryMedium, .huge)
        containerView.layer.cornerRadius = 22
    }
    
    private func configureTexts() {
        titleLabel.text = "FORGET_PASSWORD_TITLE".localized
        subtitleLabel.text = "FORGET_PASSWORD_SUBTITLE".localized
        resetConfirmationLabel.text = "RESET_CONFIRMATION".localized
        
        actionButton.config(title: "RESET_PASSWORD_BUTTON".localized, type: .primary, font: .font(.primaryBold, .medium))
        
        emailStackView.titleText = "EMAIL_TITLE".localized
        emailStackView.textField.setPlaceHolder(text: "EMAIL_PLACEHOLDER".localized)
        emailStackView.attributedAccessoryText = NSAttributedString(string: "EMAIL_HINT".localized)
    }
    
    private func bindObservables() {
        configureValidators()
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            switch self.viewModel.state {
            
            case .initial, .refreshing:
                debugPrint("initial & refreshing LoginViewController")
                
            case .loading:
                debugPrint("loading LoginViewController")
                self.actionButton.status = .disabled
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result LoginViewController")
                self.actionButton.status = .normal
                self.showLoadingIndicator(visible: false)
                self.configureForResetConfirmation()
            }
        }
    }
    
    private func passwordReset() {
        guard let email = emailStackView.textField.text else { return }
        view.endEditing(true)
        viewModel.resetPassword(email: email)
    }
    
    override func viewTapped(_ sender: UITapGestureRecognizer) {
        super.viewTapped(sender)
        actionButton.status = viewModel.isResetPasswordEnabled() ? .normal : .disabled
    }
    
    override func handleError(_ error: Error?) {
        super.handleError(error)
        actionButton.status = .normal
        
        if (error as? APIError)?.mapNetworkError() == .unauthorized {
            emailStackView.showError(true)
        }
    }
    
    private func configureForResetConfirmation() {
        emailStackView.isHidden = true
        resetConfirmationLabel.isHidden = false
        actionButton.config(title: "LOGIN_BUTTON".localized, type: .primary, font: .font(.primaryBold, .medium))
    }
}

// MARK: - Actions
extension ForgetPasswordViewController {
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        
        if viewModel.isPasswordResetDone {
            (coordinator as? AuthenticationCoordinator)?.didFinish(self)
        } else {
            passwordReset()
        }
    }
}

// MARK: - UITextFieldDelegate
extension ForgetPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newLength = text.count + string.count - range.length
        return newLength <= Constants.Login.inputsMaxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let textField = textField as? OTextField else {
            return
        }
    
        textField.isActive = false
        emailStackView.showError(!viewModel.emailIsValid)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        emailStackView.showError(false)
        
        if let textField = textField as? OTextField {
            textField.isActive = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        guard let nextTextField = textField.superview?.superview?.viewWithTag(nextTag) else {
            /// reached last one
            if viewModel.isResetPasswordEnabled() {
                textField.resignFirstResponder()
                passwordReset()
            }
            return viewModel.isResetPasswordEnabled()
        }
        
        nextTextField.becomeFirstResponder()
        return false
    }
}

// MARK: - OTextFieldStackViewDelegate
extension ForgetPasswordViewController: OTextFieldStackViewDelegate {
    
    func errorButtonTapped() {
        debugPrint("ForgetPasswordViewController errorButtonTapped")
    }

}

// MARK: - Validators
extension ForgetPasswordViewController {
    
    private func configureValidators() {
        
        /// username input validation
        emailStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool? in
            
            guard let text = input else { return false }
            return text.isValidEmail()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self, let valid = valid else { return }
            self.emailStackView.showError(!valid)
            self.viewModel.emailIsValid = valid
            self.actionButton.status = self.viewModel.isResetPasswordEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
    }
}

// MARK: Injectable
extension ForgetPasswordViewController: Injectable {
    
    typealias Payload = ForgetPasswordViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
