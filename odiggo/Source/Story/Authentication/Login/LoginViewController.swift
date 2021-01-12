//
//  LoginViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

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

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        
        configureViews()
        
        bindObservables()
    }
    
    private func styleNavigationItem() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func configureViews() {
        
        configureTexts()
        
        usernameStackView.textfieldType = .email
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
        loginButton.config(title: "LOGIN_BUTTON".localized, type: .primary(), font: .font(.primaryBold, .medium))
        
        googleButton.config(title: "GOOGLE".localized, image: UIImage(named: "google-icon"),
                            type: .outline, font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        facebookButton.config(title: "FACEBOOK".localized, image: UIImage(named: "facebook-icon"),
                              type: .primary(backgroundColor: .denimBlue), font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        appleButton.config(title: "APPLE".localized, image: UIImage(named: "apple-icon"),
                           type: .primary(backgroundColor: .black), font: .systemFont(ofSize: 14), alignment:  .textTrailing)
        
        usernameStackView.titleText = "EMAIL_TITLE".localized
        usernameStackView.textField.setPlaceHolder(text: "EMAIL_PLACEHOLDER".localized)
        usernameStackView.attributedAccessoryText = NSAttributedString(string: "EMAIL_HINT".localized)
        
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
                self.loginButton.status = .disabled
                self.showLoadingIndicator(visible: true)
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result LoginViewController")
                self.loginButton.status = self.viewModel.isLoginEnabled() ? .normal : .disabled
                self.showLoadingIndicator(visible: false)
                (self.coordinator as? AuthenticationCoordinator)?.didFinish(self)
            }
        }
    }
    
    private func login() {
        guard let email = usernameStackView.textField.text,
              let password = passwordStackView.textField.text else { return }
        view.endEditing(true)
        viewModel.login(email: email, password: password)
    }
    
    override func viewTapped(_ sender: UITapGestureRecognizer) {
        super.viewTapped(sender)
        loginButton.status = viewModel.isLoginEnabled() ? .normal : .disabled
    }
    
    override func handleError(_ error: Error?) {
        
        showLoadingIndicator(visible: false)
        loginButton.status = viewModel.isLoginEnabled() ? .normal : .disabled
        
        if (error as? APIError)?.mapNetworkError() == .unauthorized {
            passwordStackView.showError(true)
        } else {
            super.handleError(error)
        }
    }
    
    override func retry() {
        login()
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
        handleAppleIdRequest()
    }
    
    @IBAction func forgetPasswordTapped(_ sender: OButton) {
        (coordinator as? AuthenticationCoordinator)?.startForgetPassword()
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
        usernameStackView.showError(!viewModel.usernameIsValid)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        passwordStackView.showError(false)
        usernameStackView.showError(false)
        
        if let textField = textField as? OTextField {
            textField.isActive = true
            
            switch textField {
            case passwordStackView.textField:
                viewModel.passwordIsValid = false
                loginButton.status = viewModel.isLoginEnabled() ? .normal : .disabled
                
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
            if viewModel.isLoginEnabled() {
                textField.resignFirstResponder()
                login()
            }
            return viewModel.isLoginEnabled()
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
            
            guard let text = input else { return false }
            return text.isValidEmail()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self, let valid = valid else { return }
            self.usernameStackView.showError(!valid)
            self.viewModel.usernameIsValid = valid
            self.loginButton.status = self.viewModel.isLoginEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
        
        /// password validation
        passwordStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool in
            
            guard let input = input else { return false }
            return input.isValidPassword()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self else { return }
            self.viewModel.passwordIsValid = valid
            self.loginButton.status = self.viewModel.isLoginEnabled() ? .normal : .disabled
            
        }).disposed(by: disposeBag)
    }
}

// MARK: ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func handleAppleIdRequest() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email ?? "n/a"
            let fullName = appleIDCredential.fullName
            debugPrint("User id is \(userIdentifier) Email id is \(email) Full name is \(String(describing: fullName))")
            
            viewModel.login(with: appleIDCredential)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint("authorizationController \(error.localizedDescription)")
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
