//
//  Tabbar.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 16/01/2021.
//

import UIKit

@IBDesignable
class Tabbar: UITabBar {

    private var shapeLayer: CALayer?
    private let logoImage = UIImage(named: "tabbar-logo-icon")
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShape()
    }
    
    private func drawShape() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        shapeLayer.shadowOpacity = 0.26
        shapeLayer.shadowOffset = CGSize(width: 0, height: 4)
        shapeLayer.shadowRadius = 3
        shapeLayer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
        addMiddleImage()
    }
    
    private func createPathCircle() -> CGPath {

        let radius: CGFloat = 37
        let path = UIBezierPath()
        let centerWidth = frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0),
                    radius: radius, startAngle: CGFloat(180).degreesToRadians,
                    endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.close()
        return path.cgPath
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
    
    /// Setup Middle Image
    private func addMiddleImage() {
        
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        logoImageView.image = logoImage
        logoImageView.contentMode = .center
        
        var imageFrame = logoImageView.frame
        imageFrame.origin.y = bounds.height - imageFrame.height - (imageFrame.height / 1.5)
        imageFrame.origin.x = bounds.width / 2 - imageFrame.size.width / 2
        logoImageView.frame = imageFrame

        logoImageView.backgroundColor = UIColor.color(color: .scarlet)
        logoImageView.layer.cornerRadius = imageFrame.height / 2
        addSubview(logoImageView)

        layoutIfNeeded()
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
