//
//  CalculatorGraphViewController.swift
//  Calculator
//
//  Created by Marco Marchini on 20/05/15.
//  Copyright (c) 2015 Mike Ocho. All rights reserved.
//

import UIKit

class CalculatorGraphViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "move:"))
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: "moveOrigin:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapRecognizer)
        }
    }

}
