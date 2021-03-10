//
//  ExtensionUIViewController.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension UIViewController {
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     UIViewController extension - show alert view.
     
     ### Usage Example: ###
     ```swift
     import GGITCommon
     ...
     
     UIViewController().showAlertView(title: "Title", message: "message to display", actionTitle: "Action Title", popViewController: false, completion: {
     
     }
     ```
     */
    open func showAlertView(title: String, message: String, actionTitle: String, popViewController: Bool ,completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            if popViewController {
                self.navigationController?.popViewController(animated: true)
            }
            
            completion()
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     UIViewController extension - show alert view.
     
     ### Usage Example: ###
     ```swift
     import GGITCommon
     ...
     
     UIViewController().showAlertView(title: "Title", message: "message to display", actionAcceptTitle: "OK", actionDeclineTitle: "Cancel", completion: {(isAccept) in
     
     }
     ```
     */
    open func showAlertView(title: String, message: String, actionAcceptTitle: String, actionDeclineTitle:String, completion: @escaping (_ isAccept:Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let acceptAction = UIAlertAction(title: actionAcceptTitle, style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            
            completion(true)
            
        }
        let declineAction = UIAlertAction(title: actionDeclineTitle, style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            
            completion(false)
            
        }
        
        
        alertController.addAction(acceptAction)
        alertController.addAction(declineAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
