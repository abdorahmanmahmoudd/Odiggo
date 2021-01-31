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
    
    var hightlightedDotSelection: Bool = true {
        didSet {
            updateDotsAppearance()
        }
    }
    
    @IBInspectable
    var pageIndicatorTintColor: UIColor? = .lightGray
    
    @IBInspectable
    var currentPageIndicatorTintColor: UIColor? = .darkGray
    
    /// Constraint constants
    private let dotWidthPercentage: CGFloat = 0.375 /// 9 : 24
    private let selectDotWidthPercentage: CGFloat = 2.2 /// 9 : 20
    private let maxDotHeight: CGFloat = 9
    private var customSpacing: CGFloat {
        return hightlightedDotSelection ? 7 : 5
    }
    
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
    
    /// configure dot views constraints dynamically based on view height
    private func configureDotView(dot: UIView, with index: Int = 0) {
        
        var dotHeight = bounds.height * dotWidthPercentage
        if dotHeight > maxDotHeight {
            dotHeight = maxDotHeight
        }

        if let heightConstraint = dot.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = dotHeight
        } else {
            dot.heightAnchor.constraint(equalToConstant: dotHeight).isActive = true
        }
        
        let dotWidth = dotHeight
        let newSelectedDotWidth = hightlightedDotSelection ? dotHeight * selectDotWidthPercentage : dotHeight
        
        dot.layer.cornerRadius = dotWidth / 2
        dot.layer.masksToBounds = true
        
        let newWidthConstant = index == currentPage ? newSelectedDotWidth : dotWidth
        
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

