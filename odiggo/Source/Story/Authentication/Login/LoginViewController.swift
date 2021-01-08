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

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        
        configureViews()
        
        bindObservables()
    }
    
    private func configureViews() {
        
        configureTexts()
        
        usernameStackView.textfieldType = 2
        usernameStackView.textfieldDelegate = self
        passwordStackView.textfieldDelegate = self
        
        titleLabel.font = .font(.primaryBold, .huge)
        subtitleLabel.font = .font(.primaryRegular, .medium)
        containerView.layer.cornerRadius = 22
    }
    
    private func styleNavigationItem() {
        navigationController?.navigationBar.barStyle = .black
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
        passwordStackView.titleText = "PASSWORD_TITLE".localized
        passwordStackView.textField.setPlaceHolder(text: "PASSWORD_PLACEHOLDER".localized)
    }
    
    private func bindObservables() {
        
        configureValidators()
        
    }
    
    private func configureValidators() {
        
        /// username input validation
        usernameStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool? in
            
            guard let text = input, !text.isEmpty else { return nil }
            return text.hasContent()
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self, let valid = valid else { return }
            self.usernameStackView.showError(!valid)
            self.loginButton.isEnabled = valid
            
        }).disposed(by: disposeBag)
        
        /// password validation
        passwordStackView.textField.rx.text.observeOn(MainScheduler.instance).map({ (input) -> Bool in
            
            guard let inputLength = input?.count else { return false }
            return inputLength >= Constants.Login.passwordMinimumLength
            
        }).subscribe(onNext: { [weak self] (valid) in
            
            guard let self = self else { return }
            self.loginButton.isEnabled = valid
            
        }).disposed(by: disposeBag)
    }

}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else {
//            return true
//        }
//
//        let newLength = text.count + string.count - range.length
//
//        switch textField {
//        case nameStackView.onboardTextfield:
//            return newLength <= 40
//        case pincodeStackView.onboardTextfield:
//            return showPlaceholders(text, newText: string, textField: textField, newLength: newLength)
//        default:
//            return true
//        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let textField = textField as? VDLOnboardingTextfield else {
//            return
//        }
//
//        textField.isActive = false
//
//        switch textField {
//        case pincodeStackView.onboardTextfield:
//            if textField.text?.contains("•") == true {
//                textField.text = ""
//            }
//        default:
//            break
//        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let textField = textField as? OTextField else {
            return true
        }
//
//        textField.isActive = true
//        switch textField {
//        case usernameStackView.textField:
//            nameIsValid = false
//            nextIsEnabled()
//        case pincodeStackView.onboardTextfield:
//            textField.attributedText = NSMutableAttributedString(string: "••••").setOpacityForRange(range: NSRange(location: 1, length: Constants.pincodeMinNumber - 1))
//        default:
//            break
//        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let nextTag = textField.tag + 1
//        guard let nextTextField = textField.superview?.superview?.viewWithTag(nextTag), ageGroup == .adult else {
//            let save = nextIsEnabled()
//            if save == true {
//                textField.resignFirstResponder()
//                createProfile()
//            }
//            return save
//        }
//
//        nextTextField.becomeFirstResponder()
        return false
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
