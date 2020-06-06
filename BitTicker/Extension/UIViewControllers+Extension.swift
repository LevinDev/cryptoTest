//
//  UIViewControllers+Extension.swift
//  BitTicker
//
//  Created by Levin varghese on 05/06/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
      func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
      }
    
    func showHud(title: String? = nil, message: String?) {
        HUD.show(.labeledProgress(title: title, subtitle: message), onView: self.view)
    }
    
    func hideHud() {
        DispatchQueue.main.async {
            HUD.hide(afterDelay: 0.1)
        }
    }
}
