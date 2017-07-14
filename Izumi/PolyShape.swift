//
//  PolyShape.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 22.01.17.
//  Copyright © 2017 Ilya Kosolapov. All rights reserved.
//

import UIKit
@IBDesignable
class PolyShape: UIView {
    
    let basePoint: CGPoint = CGPoint(x: 87.0, y: 56.0)
    
    @IBInspectable var mainColor: UIColor = UIColor(red: 52.0, green: 40.0, blue: 255.0, alpha: 1.0)

    override func draw(_ rect: CGRect)
    {
        drawRingFittingInsideView(rect: rect)
    }
    
    internal func setColor(newColor: UIColor, rect: CGRect) {
        self.redrawFiller()
        self.mainColor = newColor
        self.drawRingFittingInsideView(rect: rect)
    }
    
    internal func redrawFiller() {
        self.layer.sublayers?.removeAll()
    }
    
    internal func drawRingFittingInsideView(rect: CGRect)->()
    {
        let shapePath = UIBezierPath()
        shapePath.move(to: basePoint)
        shapePath.addLine(to: CGPoint(x: 92.0, y: 54.0))
        shapePath.addCurve(
            to: CGPoint(x: 138.0, y: 52.0),
            controlPoint1: CGPoint(x: 88.0, y: 84.0),
            controlPoint2: CGPoint(x: 140.0, y: 93.0)
        )
        shapePath.addLine(to: CGPoint(x: 150.0, y: 52.0))
        shapePath.addCurve(
            to: basePoint,
            controlPoint1: CGPoint(x: 161.0, y: 107.0),
            controlPoint2: CGPoint(x: 80.0, y: 107.0)
        )
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapePath.cgPath
        shapeLayer.fillColor = mainColor.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
}
