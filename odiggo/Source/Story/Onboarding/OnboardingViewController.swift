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
    
    /// Track presented slide index
    private var currentSlide = 0
    
    /// We do not count the welcome screen
    private var slidesCounter: Int {
        return onboardingSlides.count - 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        configure()
    }
    
    private func styleNavigationItem() {
        
    }
    
    private func configure() {
        
        scrollView.delegate = self
                
        configureOnboardingFlow()
        
        configureSlideScrollView()
    }
    
    private func configureOnboardingFlow() {
        
        /// Add the slides based on the `OnboardingFlow` enum cases.
        let dataSource = OnboardingFlow.allCases
        
        for item in dataSource {
            
            if let view  = item.view.init().loadNib() as? WelcomeView {
                
                view.configure(withSubtitle: item.data.subtitle, coverImage: item.data.icon ?? "")
                onboardingSlides.append(view)
                view.getStartedTapped = { [weak self] in
                    self?.nextSlide()
                }
                
            } else if let view = item.view.init().loadNib() as? OnboardingView {
                
                view.configure(title: item.data.title, subtitle: item.data.subtitle,
                               coverImage: item.data.icon ?? "")
                onboardingSlides.append(view)
                view.skipTapped = { [weak self] in
                    self?.getStarted()
                }
                
                view.nextTapped = { [weak self] in
                    self?.nextSlide()
                }
                
                view.pageControlValueChange = { [weak self] page in
                    self?.didSelectPageControl(page)
                }
                
            } else if let view = item.view.init().loadNib() as? GetStartedView {
                
                view.configure(title: item.data.title, subtitle: item.data.subtitle,
                               coverImage: item.data.icon ?? "")
                onboardingSlides.append(view)
                
                view.getStartedTapped = { [weak self] in
                    self?.getStarted()
                }
                
                view.pageControlValueChange = { [weak self] page in
                    self?.didSelectPageControl(page)
                }
            }
        }
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
            
            configurePageControl(of: onboardingSlides[i], 0)
        }
    }
    
    private func configurePageControl(of view: UIView, _ currentPage: Int) {
        
        if let onboardingView = view as? OnboardingView {
            onboardingView.setPages(slidesCounter)
            onboardingView.setCurrentPage(currentPage)
            
        } else if let getStartedView = view as? GetStartedView {
            getStartedView.setPages(slidesCounter)
            getStartedView.setCurrentPage(currentPage)
        }
    }
    
    private func updatePageControl(withIndex index: Int) {
        if let slide = onboardingSlides[safe: index] {
            configurePageControl(of: slide, index - 1)
        }
    }
}

// MARK: Actions
extension OnboardingViewController {

    private func nextSlide() {
        currentSlide += 1
        updateScrollViewOffset()
        updatePageControl(withIndex: currentSlide)
    }
    
    private func getStarted() {
        (coordinator as? OnboardingCoordinator)?.didFinish()
    }
    
    private func didSelectPageControl(_ page: Int) {
        
        guard currentSlide != page + 1 else {
            return
        }
        
        currentSlide = page + 1
        updateScrollViewOffset()
        updatePageControl(withIndex: currentSlide)
    }
    
    private func updateScrollViewOffset() {
        let newOffset = CGFloat(currentSlide) * view.bounds.width
        scrollView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: true)
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
        currentSlide = newTargetIndex
    }
}
