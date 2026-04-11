//
//  UIViewController+Alerts.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

extension UIViewController {
    
    /* Presents a standard alert with a title, message, and a default action.
     - Parameters:
     - title: The title of the alert.
     - message: The message body of the alert.
     - actionTitle: The title of the primary action button.
     - completion: A closure that executes when the action is tapped.
     */
    func presentAlert(
        title: String,
        message: String,
        actionTitle: String = "OK",
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        
        // Present on the main thread to ensure UI safety
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
