//
//  PageControl.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 05/01/2021.
//

import UIKit

@IBDesignable
final class PageControl: UIControl {
    
    // MARK: - Properties
    private var numberOfDots = [UIView]() {
        didSet{
            if numberOfDots.count == numberOfPages {
                setupViews()
            }
        }
    }
    
    @IBInspectable var numberOfPages: Int = 0 {
        didSet{
            for tag in 0 ..< numberOfPages {
                let dot = getDotView()
                dot.tag = tag
                dot.backgroundColor = pageIndicatorTintColor
                self.numberOfDots.append(dot)
            }
        }
    }
    
    var currentPage: Int = 0 {
        didSet{
            print("CurrentPage is \(currentPage)")
            updateDotsAppearance()
        }
    }
    
    override var bounds: CGRect {
        didSet{
            updateDotsAppearance()
        }
    }
    
    @IBInspectable
    var pageIndicatorTintColor: UIColor? = .lightGray
    
    @IBInspectable
    var currentPageIndicatorTintColor: UIColor? = .darkGray
    
    /// Constraint constants
    private let dotWidth: CGFloat = 9
    private let selectedDotWidth: CGFloat = 20
    private let customSpacing: CGFloat = 7
    
    /// Dots stack view container
    private lazy var stackView = UIStackView(frame: bounds)
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        
        self.numberOfDots.forEach { (dot) in
            self.stackView.addArrangedSubview(dot)
        }
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = customSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        addConstraints([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    // MARK: - Helper methods
    private func getDotView() -> UIView {
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                             action: #selector(onPageControlTapped(_:))))
        return dot
    }
    
    private func updateDotsAppearance() {
        numberOfDots.enumerated().forEach { page, dot in
            dot.backgroundColor = page == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
            configureDotView(dot: dot, with: page)
        }
    }
    
    private func configureDotView(dot: UIView, with index: Int = 0) {
        
        dot.layer.cornerRadius = dotWidth / 2
        dot.layer.masksToBounds = true
        
        if dot.constraints.first(where: { $0.firstAttribute == .height }) == nil {
            dot.heightAnchor.constraint(equalToConstant: dotWidth).isActive = true
        }
        
        let newWidthConstant = index == currentPage ? selectedDotWidth : dotWidth
        
        if let widthConstraint = dot.constraints.first(where: { $0.firstAttribute == .width }) {
            widthConstraint.constant = newWidthConstant
        } else {
            dot.widthAnchor.constraint(equalToConstant: newWidthConstant).isActive = true
        }
    }
    
    // MARK: - Actions
    @objc
    private func onPageControlTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedDot = sender.view else { return }
        currentPage = selectedDot.tag
        sendActions(for: .valueChanged)
    }
}

