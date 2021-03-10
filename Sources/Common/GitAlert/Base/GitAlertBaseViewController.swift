//
//  GitAlertBaseViewController.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/// Class to build `GitAlertBaseViewController`
public class GitAlertBaseViewController: UIViewController {
    
    private(set) var keyboardRect = CGRect.zero
    
    func listenKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(GitAlertBaseViewController.keyboardWillShow(sender:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GitAlertBaseViewController.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        guard let userInfo = sender.userInfo else {
            return
        }
        
        if let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue{
            self.keyboardRect = keyboardRect
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        keyboardRect = CGRect.zero
    }
}
