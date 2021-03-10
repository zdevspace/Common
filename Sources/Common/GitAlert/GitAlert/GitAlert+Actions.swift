//
//  GitAlert+Actions.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension GitAlert {
    
    @objc func tapOnView(_ sender: UITapGestureRecognizer) {
        if tapToDismiss && keyboardRect == .zero {
            let point = sender.location(in: self.view)
            
            let isPointInGitAlertView = gitAlertView.frame.contains(point)
            if !isPointInGitAlertView {
                dismiss(animated: true) {
                    print("dismissed")
                }
            }
        } else {
            self.view.endEditing(true)
        }
    }
}

extension GitAlert: GitAlertActionCallbackProtocol {
    
    func didTapOnAction() {
        if dismissOnActionTapped {
            dismiss(animated: true) {
                print("dismissed")
            }
        }
    }
}
