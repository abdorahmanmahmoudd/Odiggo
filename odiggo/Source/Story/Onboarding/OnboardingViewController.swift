//
//  OnboardingViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit

final class OnboardingViewController: BaseViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var onboardingSlides: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        configure()
    }
    
    private func styleNavigationItem() {
        
    }
    
    private func configure() {
        
        scrollView.delegate = self
                
        /// Add the slides based on the `OnboardingFlow` enum cases.
        let dataSource = OnboardingFlow.allCases
        
        for item in dataSource {
            if let view  = item.view.init().loadNib() as? WelcomeView {
                view.configure(withSubtitle: item.data.subtitle, coverImage: item.data.icon ?? "")
                onboardingSlides.append(view)
                view.getStartedTapped = { [weak self] in
                    self?.welcomeGetStartedTapped()
                }
                
            } else if let view = item.view.init().loadNib() as? OnboardingView {
                view.configure(title: item.data.title, subtitle: item.data.subtitle,
                               coverImage: item.data.icon ?? "")
                onboardingSlides.append(view)
                view.skipTapped = { [weak self] in
                    self?.skipTapped()
                }
                
                view.nextTapped = { [weak self] in
                    self?.nextTapped()
                }
                
            } else if let view = item.view.init().loadNib() as? GetStartedView {
                view.configure(title: item.data.title, subtitle: item.data.subtitle,
                               coverImage: item.data.icon ?? "")
                onboardingSlides.append(view)
                view.getStartedTapped = { [weak self] in
                    self?.getStartedTapped()
                }
            }
        }
        
        configureSlideScrollView()
    }
    
    private func configureSlideScrollView() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(onboardingSlides.count),
                                        height: UIScreen.main.bounds.height)
        
        for i in 0 ..< onboardingSlides.count {
            
            onboardingSlides[i].frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0,
                                               width: UIScreen.main.bounds.width,
                                               height: UIScreen.main.bounds.height)
            scrollView.addSubview(onboardingSlides[i])
            
            configurePageControl(of: onboardingSlides[i], 1)
        }
    }
    
    private func configurePageControl(of view: UIView, _ currentPage: Int) {
        
        if let onboardingView = view as? OnboardingView {
            onboardingView.setPages(onboardingSlides.count - 1)
            onboardingView.setCurrentPage(currentPage - 1)
            
        } else if let getStartedView = view as? GetStartedView {
            getStartedView.setPages(onboardingSlides.count - 1)
            getStartedView.setCurrentPage(currentPage - 1)
        }
    }
    
    private func updatePageControl(withIndex index: Int) {
        if let slide = onboardingSlides[safe: index] {
            configurePageControl(of: slide, index)
        }
    }
}

// MARK: Actions
extension OnboardingViewController {
    
    private func welcomeGetStartedTapped() {
        
    }
    
    private func skipTapped() {
        
    }
    
    private func nextTapped() {
        
    }
    
    private func getStartedTapped() {
        
    }
}

// MARK: UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    
    // Updating the PageControl current page
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let slideWidth = Float(view.frame.width)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0

        /// to determine wether we are scrolling to the next or the previous item
        if targetOffset > currentOffset {
            /// next item offset
            newTargetOffset = ceilf(currentOffset / slideWidth) * slideWidth
            
        } else {
            /// previous item offset
            newTargetOffset = floorf(currentOffset / slideWidth) * slideWidth
        }

        /// to handle scroll before first item
        if newTargetOffset < 0 {
            newTargetOffset = 0

        } else if newTargetOffset > Float(scrollView.contentSize.width) { /// to handle scroll after last item
            newTargetOffset = Float(scrollView.contentSize.width)
        }

        /// calculate new target index
        let newTargetIndex = Int(newTargetOffset / slideWidth)

        /// Update page control with the new index
        updatePageControl(withIndex: newTargetIndex)
    }
}
