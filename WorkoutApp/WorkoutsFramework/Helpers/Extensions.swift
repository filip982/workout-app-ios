//
//  Extensions.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit

public extension CGFloat {
    
    static func rl_grid(_ n: Int) -> CGFloat {
        return CGFloat(n) * 4.0
    }
}

extension Int {
    func double() -> Double {
        Double(self)
    }

    func cgFloat() -> CGFloat {
        CGFloat(self)
    }
    
    func timeInterval() -> TimeInterval {
        TimeInterval(self)
    }

}

extension UIViewController {
    func add(_ child: UIViewController, to container: UIView? = nil) {
        addChild(child)
        if let container = container {
            container.addSubview(child.view)
            child.view.frame = container.frame
        } else {
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
