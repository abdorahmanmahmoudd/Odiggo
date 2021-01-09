//
//  SignupViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 08/01/2021.
//

import UIKit
import RxSwift

final class SignupViewController: BaseViewController {
    
    /// UI Outlets
    @IBOutlet private weak var passwordConfirmationStackView: OTextFieldStackView!
    @IBOutlet private weak var passwordStackView: OTextFieldStackView!
    @IBOutlet private weak var emailStackView: OTextFieldStackView!
    @IBOutlet private weak var usernameStackView: OTextFieldStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var signupButton: OButton!
    @IBOutlet private weak var googleButton: OButton!
    @IBOutlet private weak var facebookButton: OButton!
    @IBOutlet private weak var appleButton: OButton!
    @IBOutlet private weak var accountQuestionLabel: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    
    /// RxSwift
    let disposeBag = DisposeBag()
    
    private var viewModel: SignupViewModel!
    
    private var usernameIsValid = false
    private var passwordIsValid = false
    private var emailIsValid = false
    private var passwordConfirmationIsValid = false

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        
        configureViews()
        
        bindObservables()
    }
    
    private func styleNavigationItem() {

    }
    
    private func configureViews() {
        
        configureTexts()
        
        usernameStackView.delegate = self
        usernameStackView.textfieldDelegate = self
        
        emailStackView.textfieldType = .email
        emailStackView.delegate = self
        emailStackView.textfieldDelegate = self
        
        passwordStackView.textfieldType = .password
        passwordStackView.delegate = self
        passwordStackView.textfieldDelegate = self
        
        passwordConfirmationStackView.textfieldType = .password
        passwordConfirmationStackView.delegate = self
        passwordConfirmationStackView.textfieldDelegate = self
        passwordConfirmationStackView.lastTextfield = true
        
        titleLabel.font = .font(.primaryBold, .huge)
        subtitleLabel.font = .font(.primaryRegular, .medium)
        accountQuestionLabel.font = .font(.primaryRegular, .small)
        loginLabel.font = .font(.primaryRegular, .little)
        containerView.layer.cornerRadius = 22
    }
    
    private func configureTexts() {
        titleLabel.text = "WELCOME_BACK".localized
        subtitleLabel.text = "LOGIN_SUBTITLE".localized
        accountQuestionLabel.text = "LOGIN_Q".localized
        loginLabel.text = "LOGIN".localized

        signupButton.config(title: "SIGNUP_BUTTON".localized, type: .primary, font: .font(.primaryBold, .medium))
        
        googleButton.config(title: "GOOGLE".localized, image: UIImage(named: "error-icon"),
                            type: .outline, font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        facebookButton.config(title: "FACEBOOK".localized, image: UIImage(named: "error-icon"),
                              type: .outline, font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        appleButton.config(title: "APPLE".localized, image: UIImage(named: "error-icon"),
                           type: .outline, font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        usernameStackView.titleText = "USERNAME_TITLE".localized
        usernameStackView.textField.setPlaceHolder(text: "USERNAME_TITLE".localized)
        usernameStackView.attributedAccessoryText = NSAttributedString(string: "USERNAME_HINT".localized)
        
        emailStackView.titleText = "EMAIL_TITLE".localized
        emailStackView.textField.setPlaceHolder(text: "EMAIL_PLACEHOLDER".localized)
        emailStackView.attributedAccessoryText = NSAttributedString(string: "EMAIL_HINT".localized)
        
        passwordStackView.titleText = "PASSWORD_TITLE".localized
        passwordStackView.textField.setPlaceHolder(text: "PASSWORD_PLACEHOLDER".localized)
        passwordStackView.attributedAccessoryText = NSAttributedString(string: "PASSWORD_HINT".localized)
        
        passwordConfirmationStackView.titleText = "PASSWORD_CONFIRMATION_TITLE".localized
        passwordConfirmationStackView.textField.setPlaceHolder(text: "PASSWORD_CONFIRMATION_TITLE".localized)
        passwordConfirmationStackView.attributedAccessoryText = NSAttributedString(string: "PASSWORD_CONFIRMATION_HINT".localized)
    }
    
    private func bindObservables() {
        configureValidators()
    }
    
    private func isSignupEnabled() -> Bool {
        return usernameIsValid && passwordIsValid && passwordConfirmationIsValid && emailIsValid
    }
    
    private func signup() {
        
        guard let username = usernameStackView.textField.text,
              let password = passwordStackView.textField.text,
              let email = emailStackView.textField.text else { return }
        
        view.endEditing(true)
        viewModel.signup(username: username, email: email, password: password)
    }
    
    override func viewTapped(_ sender: UITapGestureRecognizer) {
        super.viewTapped(sender)
        signupButton.status = isSignupEnabled() ? .normal : .disabled
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        (coordinator as? AuthenticationCoordinator)?.loginTapped()
    }
}

// MARK: - UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    
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
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        passwordConfirmationStackView.showError(false)
        passwordStackView.showError(false)
        usernameStackView.showError(false)
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
            if isSignupEnabled() {
                textField.resignFirstResponder()
                signup()
            }
            return isSignupEnabled()
        }
        
        nextTextField.becomeFirstResponder()
        return false
    }
}

// MARK: - OTextFieldStackViewDelegate
extension SignupViewController: OTextFieldStackViewDelegate {
    
    func errorButtonTapped() {
        debugPrint("SignupViewController errorButtonTapped")
    }
}

// MARK: - Validations
extension SignupViewController {
    
    private func configureValidators() {
        
        /// username input validation
        usernameStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool in
            
            guard let text = input, !text.isEmpty else { return false }
            return text.hasContent()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self else { return }
            self.usernameStackView.showError(!valid)
            self.usernameIsValid = valid
            self.signupButton.status = self.isSignupEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
        
        /// Email input validation
        emailStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool in
            
            guard let text = input else { return false }
            return text.isValidEmail()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self else { return }
            self.emailStackView.showError(!valid)
            self.emailIsValid = valid
            self.signupButton.status = self.isSignupEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
        
        /// password validation
        passwordStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool in
            
            guard let inputLength = input?.count else { return false }
            return inputLength >= Constants.Login.passwordMinimumLength
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self else { return }
            self.passwordIsValid = valid
            self.signupButton.status = self.isSignupEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
        
        /// password confirmation validation
        passwordConfirmationStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool in
            return input == self.passwordStackView.textField.text
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self else { return }
            self.passwordConfirmationIsValid = valid
            self.signupButton.status = self.isSignupEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
    }
}

// MARK: - Injectable
extension SignupViewController: Injectable {
    
    typealias Payload = SignupViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
