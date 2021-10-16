//
//  KeyboardHandling.swift
//  WorkoutsFramework
//
//  Created by Filip Miladinovic
//

import UIKit

protocol KeyboardHandling {
    var bottomConstraint: NSLayoutConstraint! { get set }
}

extension KeyboardHandling where Self: UIViewController {
    
    func registerForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(forName: UIResponder.keyboardWillShowNotification,
                           object: nil,
                           queue: OperationQueue.main,
                           using: keyboardWillShow(_:))
        center.addObserver(forName: UIResponder.keyboardWillHideNotification,
                           object: nil,
                           queue: OperationQueue.main,
                           using: keyboardWillHide(_:))
    }
    
    func removeKeyboardObservers() {
        self.view.endEditing(true)
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        
        bottomConstraint.constant = -keyboardHeight
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0,
                       animations: {
                        self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        
        view.layoutIfNeeded()
        bottomConstraint.constant = 0.0
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0,
                       animations: {
                        self.view.layoutIfNeeded()
        })
    }
    
}
