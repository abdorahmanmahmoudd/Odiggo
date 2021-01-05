//
//  OPageControl.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 05/01/2021.
//

import UIKit

final class OPageControlView: UIView {

    /// Set this varieble to create the dots for pages
    var pages: Int = 0 {
        didSet {
            /// Create dot for each page
            dots = (0 ..< pages).map { _ in
                UIImageView(frame: CGRect(origin: .zero,
                                          size: CGSize(width: dotSize, height: dotSize)))
                
            }
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }

    var currentPage: Int = 0 {
        didSet {
            if (0 ..< centerDots).contains(currentPage - pageOffset) {
                centerOffset = currentPage - pageOffset
            } else {
                pageOffset = currentPage - centerOffset
            }
            updateColors()
        }
    }

    var unselectedImage = UIImage(named: "unselectedDot") {
        didSet {
            setNeedsDisplay()
        }
    }

    var selectedImage = UIImage(named: "selectedDot") {
        didSet {
            setNeedsDisplay()
        }
    }

    var maxDots = 8 {
        didSet {
            if maxDots % 2 == 1 {
                maxDots += 1
                debugPrint("maxPages has to be an even number")
            }
            invalidateIntrinsicContentSize()
            updatePositions()
        }
    }

    var centerDots = 4 {
        didSet {
            if centerDots % 2 == 1 {
                centerDots += 1
                debugPrint("centerDots has to be an even number")
            }
            invalidateIntrinsicContentSize()
            updatePositions()
        }
    }

    private let dotSize: CGFloat = 9
    private let selectedDotWidth: CGFloat = 20
    private let spacing: CGFloat = 7
    private var centerOffset = 0

    func prepareForReuse() {
        pages = 0
        currentPage = 0
        centerOffset = 0
        pageOffset = 0
        dots.removeAll()
    }

    private var pageOffset = 0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: 0.2, animations: self.updatePositions)
            }
        }
    }

    private var dots: [UIImageView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            dots.forEach(addSubview)
            updateColors()
            updatePositions()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isOpaque = false
    }

    override var intrinsicContentSize: CGSize {
        let pages = min(maxDots, self.pages)
        let width = CGFloat(pages - 1) * dotSize + selectedDotWidth + CGFloat(pages - 1) * spacing
        let height = dotSize
        return CGSize(width: width, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePositions()
    }

    private func updateColors() {

        dots.enumerated().forEach { page, dot in
            dot.image = page == currentPage ? selectedImage : unselectedImage
            dot.frame.size.width = page == currentPage ? selectedDotWidth : dotSize
        }
        setNeedsDisplay()
        invalidateIntrinsicContentSize()
    }

    private func updatePositions() {
        
        let sidePages = (maxDots - centerDots) / 2
        let horizontalOffset = CGFloat(-pageOffset + sidePages) * (dotSize + spacing) + (bounds.width - intrinsicContentSize.width) / 3
        
        dots.enumerated().forEach { page, dot in
            var newDotSize = dotSize
            if page == currentPage {
                newDotSize = selectedDotWidth
            }
            let center = CGPoint(x: horizontalOffset + bounds.minX + dotSize / 2 + (dotSize + spacing) * CGFloat(page), y: bounds.midY)
            dot.center = center
        }
    }
}
