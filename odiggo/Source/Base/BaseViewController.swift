//
//  BaseViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit
import PKHUD

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    /// Error View Controller
//    lazy var errorViewController = ErrorViewController()
    
    /// View controller's Coordinator
    weak var coordinator: Coordinator?
    
    var navigationItemStyle: NavigationItemStyle? {
        didSet {
            configureNavBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Enable swipe back gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    /// Disable pop gesture in one situation:
    /// 1) when we are on the root view controller
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == navigationController?.interactivePopGestureRecognizer else {
            return true
        }
        return (navigationController?.viewControllers.count ?? 0) > 1 ? true : false
    }

    /// Show and hide loading indicator
    func showLoadingIndicator(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
    
    /// Shared Error Handling functionality
    func handleError(_ error: Error?) {
        
        
        self.showLoadingIndicator(visible: false)
        guard let error = error as? APIError else {
            return
        }
        /// If there is an error then show error view with that error and try again button
        showErrorAlert(with: nil, message: error.errorDescription)
        
        return
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addBackButtonIfNeeded(_ tintColor: UIColor = .white) {
        navigationItem.leftBarButtonItem = UIBarButtonItem.odiggoBackButton(target: self,
                                                                            action: #selector(self.didPressBackButton),
                                                                            tintColor: tintColor)
    }
    
    @objc func didPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    /// To be overrwitten by subclasses
    func retry() {
        debugPrint("Override by view controller subclass")
    }
}

// MARK: NavigationItem
extension BaseViewController {
    
    private func configureNavBar() {
        
//        guard let navigation = navigationItem as? NavigationItem else {
//            return assertionFailure("The Navigation item should be of type ONavigationItem!")
//        }
                
        switch navigationItemStyle {
        case .homePageStyle(let items):
            hideNavigationBar()
            navigationItem.configure(with: .homePageStyle(items: items))
            
        case .searchPlaceHolderStyle(let items):
            hideNavigationBar()
            navigationItem.configure(with: .searchPlaceHolderStyle(items: items))
            
        case .none:
            debugPrint("Navigation type not set for BaseViewController")
        }
    }
    
    private func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .default
    }
}

// MARK: Error View
extension BaseViewController {
    
    /// Present an Alert with preferred Style with a custom `retryAction` otherwise it will call the default `retry` function.
    func showErrorAlert(with title: String?, message: String?,
                        preferredStyle: UIAlertController.Style = .alert, retryAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alert.addAction(UIAlertAction(title: "RETRY".localized, style: .default, handler: { [weak self] _ in

            guard let retryAction = retryAction else {
                self?.retry()
                return
            }
            retryAction()
        }))
        
        alert.addAction(UIAlertAction(title: "DISMISS".localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

//    /// Present error  view with title, message and callback
//    func showError(with title: String? = "", message: String? = "", retry: @escaping () -> ()) {
//        errorViewController.loadViewIfNeeded()
//        errorViewController.setError(withTitle: title, andMessage: message)
//        errorViewController.action = retry
//        transition(to: errorViewController)
//    }
//
//    /// Present Error view controller
//    private func transition(to viewController: UIViewController) {
//
//        /// Remove old error view if exists
//        removeErrorView()
//
//        /// Add the new error view
//        viewController.willMove(toParent: self)
//        addChild(viewController)
//        view.addSubview(viewController.view)
//        viewController.didMove(toParent: self)
//
//        /// Activate the constraints for the new error view
//        errorViewController.view.activateConstraints(for: self.view)
//    }
//
//    /// Remove Error View Controller
//    func removeErrorView() {
//
//        if errorViewController.parent != nil {
//            errorViewController.willMove(toParent: nil)
//            errorViewController.removeFromParent()
//            errorViewController.view.removeFromSuperview()
//            errorViewController.didMove(toParent: nil)
//        }
//    }
}



