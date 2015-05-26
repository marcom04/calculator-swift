//
//  GraphView.swift
//  Calculator
//
//  Created by Marco Marchini on 20/05/15.
//  Copyright (c) 2015 Mike Ocho. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func yForX(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView
{
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 50 { didSet { setNeedsDisplay() } }
    
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    var lineColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    weak var dataSource: GraphViewDataSource?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        origin = convertPoint(center, fromView: superview)      // default origin to superview's center
    }
    
    override func drawRect(rect: CGRect) {
        let axesDrawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        // iterate over every pixel across the width of the view and draw a line to (or move to if the last
        // datapoint was not valid) the next valid datapoint got from dataSource
        
        let path = UIBezierPath()
        lineColor.set()
        path.lineWidth = lineWidth
        
        var firstVal = true
        var dataPoint = CGPoint()
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            dataPoint.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.yForX((dataPoint.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    firstVal = true
                    continue
                }
                dataPoint.y = origin.y - y * scale
                if firstVal {
                    path.moveToPoint(dataPoint)
                    firstVal = false
                } else {
                    path.addLineToPoint(dataPoint)
                }
            } else {
                firstVal = true
            }
        }
        path.stroke()
    }
    
    // --- Gestures handlers
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func move(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            origin.x += translation.x
            origin.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }
    
    func moveOrigin(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }
}
