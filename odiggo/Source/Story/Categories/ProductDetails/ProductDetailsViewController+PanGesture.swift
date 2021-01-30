//
//  ProductDetailsViewController+PanGesture.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 28/01/2021.
//

import UIKit

extension ProductDetailsViewController {
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        
        case .began:
            isPanGesturing = true
            startTranslation = gesture.translation(in: view)
            productDetailsView.scrollView.isScrollEnabled = false
        
        case .changed:
            let difference = startConstant + (gesture.translation(in: view).y - startTranslation.y)
            
            if difference > defaultNavigationBarHeight {
                /// Top bounce
                let currentHeightConstant = imageContainerHeightConstraint.constant
                let biggerSize = currentHeightConstant + (difference * minImagesContainerViewHeightPercentage)
                imageContainerHeightConstraint.constant = min(0, biggerSize)

            } else if difference < -UIScreen.main.bounds.height {
                /// Bottom bounce, disabled
                imageContainerHeightConstraint.constant = -UIScreen.main.bounds.height * minImagesContainerViewHeightPercentage

            } else if difference < 0 {
                /// Normal scroll
                let smallerSize = difference * minImagesContainerViewHeightPercentage
                imageContainerHeightConstraint.constant = min(0, smallerSize)
            }
            
        case .ended, .cancelled:
            productDetailsView.scrollView.isScrollEnabled = true

            let difference = max(-UIScreen.main.bounds.height,
                                 startConstant + (gesture.translation(in: view).y - startTranslation.y))
            let velocity = gesture.velocity(in: view)

            guard difference <= defaultNavigationBarHeight else {
                snapUp()
                return
            }

            /// Animate snap
            if difference < startConstant {

                /// Scrolling down
                if velocity.y > 0 {
                    snapUp() /// The user changed direction, go back

                } else if velocity.y < 450 || difference < (startConstant - 100) {
                    snapDown() /// The user scrolled fast / far enough to snap the direction

                } else {
                    snapUp() /// The user didn't scrolled fast / far enough, go back
                }
            } else {
                /// Scrolling up
                if velocity.y < 0 {
                    snapDown() /// The user changed direction, go back

                } else if velocity.y >= 450 || difference > (startConstant + 100) {
                    snapUp() /// The user scrolled fast / far enough to snap the direction

                } else {
                    snapDown() /// The user didn't scrolled fast / far enough, go back
                }
            }
            
        case .possible, .failed:
            isPanGesturing = false
        @unknown default:
            isPanGesturing = false
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view.isKind(of: UISlider.self) {
            return false
        }
        return true
    }
    
    func toggleBounces(visibleScrollView: UIScrollView, isScrollingUp: Bool) {
        visibleScrollView.bounces = !isScrollingUp
    }
}
