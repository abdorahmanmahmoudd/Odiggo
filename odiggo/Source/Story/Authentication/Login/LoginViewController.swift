//
//  LoginViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    
    /// UI Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var usernameStackView: OTextFieldStackView!
    @IBOutlet private weak var passwordStackView: OTextFieldStackView!
    @IBOutlet private weak var forgetPasswordButton: OButton!
    @IBOutlet private weak var loginButton: OButton!
    @IBOutlet private weak var googleButton: OButton!
    @IBOutlet private weak var facebookButton: OButton!
    @IBOutlet private weak var appleButton: OButton!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var signupQuestionLabel: UILabel!
    @IBOutlet private weak var signupLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    /// RxSwift
    let disposeBag = DisposeBag()
    
    private var viewModel: LoginViewModel!
    
    private var usernameIsValid = false
    private var passwordIsValid = false

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        
        configureViews()
        
        bindObservables()
    }
    
    private func styleNavigationItem() {
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func configureViews() {
        
        configureTexts()
        
        usernameStackView.delegate = self
        usernameStackView.textfieldDelegate = self
        
        passwordStackView.textfieldType = .password
        passwordStackView.delegate = self
        passwordStackView.lastTextfield = true
        passwordStackView.textfieldDelegate = self
        
        titleLabel.font = .font(.primaryBold, .huge)
        subtitleLabel.font = .font(.primaryRegular, .medium)
        signupQuestionLabel.font = .font(.primaryRegular, .small)
        signupLabel.font = .font(.primaryRegular, .little)
        containerView.layer.cornerRadius = 22
    }
    
    private func configureTexts() {
        titleLabel.text = "WELCOME_BACK".localized
        subtitleLabel.text = "LOGIN_SUBTITLE".localized
        signupQuestionLabel.text = "SIGNUP_Q".localized
        signupLabel.text = "SIGNUP".localized
        
        forgetPasswordButton.config(title: "FORGET_PASSWORD_Q".localized, type: .text(titleColor: .pinkishRed), font: .font(.primaryMedium, 13))
        loginButton.config(title: "LOGIN_BUTTON".localized, type: .primary, font: .font(.primaryBold, .medium))
        
        googleButton.config(title: "CONTINUE_WITH_GOOGLE".localized, image: UIImage(named: "error-icon"),
                            type: .outline, font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        facebookButton.config(title: "CONTINUE_WITH_FB".localized, image: UIImage(named: "error-icon"),
                              type: .outline, font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        appleButton.config(title: "CONTINUE_WITH_APPLE".localized, image: UIImage(named: "error-icon"),
                           type: .outline, font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        usernameStackView.titleText = "USERNAME_TITLE".localized
        usernameStackView.textField.setPlaceHolder(text: "USERNAME_TITLE".localized)
        usernameStackView.attributedAccessoryText = NSAttributedString(string: "USERNAME_HINT".localized)
        
        passwordStackView.titleText = "PASSWORD_TITLE".localized
        passwordStackView.textField.setPlaceHolder(text: "PASSWORD_PLACEHOLDER".localized)
        passwordStackView.attributedAccessoryText = NSAttributedString(string: "INVALID_CREDENTIALS_MSG".localized)
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
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result LoginViewController")
                self.showLoadingIndicator(visible: false)
            }
        }
    }
    
    private func isLoginEnabled() -> Bool {
        return usernameIsValid && passwordIsValid
    }
    
    private func login() {
        guard let username = usernameStackView.textField.text,
              let password = passwordStackView.textField.text else { return }
        view.endEditing(true)
        viewModel.login(username: username, password: password)
    }
    
    override func viewTapped(_ sender: UITapGestureRecognizer) {
        super.viewTapped(sender)
        loginButton.status = isLoginEnabled() ? .normal : .disabled
    }
    
    override func handleError(_ error: Error?) {
        super.handleError(error)
        
        if (error as? APIError)?.mapNetworkError() == .unauthorized {
            passwordStackView.showError(true)
        }
    }
}

// MARK: - Actions
extension LoginViewController {
    
    @IBAction func signupTapped(_ sender: Any) {
        (coordinator as? AuthenticationCoordinator)?.startSignup()
    }
    
    @IBAction func loginButtonTapped(_ sender: OButton) {
        login()
    }
    
    @IBAction func googleButtonTapped(_ sender: OButton) {
        
    }
    
    @IBAction func facebookButtonTapped(_ sender: OButton) {
        
    }
    
    @IBAction func appleButtonTapped(_ sender: OButton) {
        
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
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
        passwordStackView.showError(false)
        usernameStackView.showError(!usernameIsValid)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        passwordStackView.showError(false)
        usernameStackView.showError(false)
        
        if let textField = textField as? OTextField {
            textField.isActive = true
            
            switch textField {
            case passwordStackView.textField:
                passwordIsValid = false
                loginButton.status = isLoginEnabled() ? .normal : .disabled
                
            default:
                break
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        guard let nextTextField = textField.superview?.superview?.viewWithTag(nextTag) else {
            /// reached last one
            if isLoginEnabled() {
                textField.resignFirstResponder()
                login()
            }
            return isLoginEnabled()
        }
        
        nextTextField.becomeFirstResponder()
        return false
    }
}

// MARK: - OTextFieldStackViewDelegate
extension LoginViewController: OTextFieldStackViewDelegate {
    
    func errorButtonTapped() {
        debugPrint("LoginViewController errorButtonTapped")
    }

}

// MARK: - Validators
extension LoginViewController {
    
    private func configureValidators() {
        
        /// username input validation
        usernameStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool? in
            
            guard let text = input, !text.isEmpty else { return false }
            return text.hasContent()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self, let valid = valid else { return }
            self.usernameStackView.showError(!valid)
            self.usernameIsValid = valid
            self.loginButton.status = self.isLoginEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
        
        /// password validation
        passwordStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool in
            
            guard let input = input else { return false }
            return input.isValidPassword()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self else { return }
            self.passwordIsValid = valid
            self.loginButton.status = self.isLoginEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
    }
}

// MARK: Injectable
extension LoginViewController: Injectable {
    
    typealias Payload = LoginViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
