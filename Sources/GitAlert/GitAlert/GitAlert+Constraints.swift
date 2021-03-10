//
//  GitAlert+Constraints.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension GitAlert {
    
    func makeContraints() {
        NSLayoutConstraint.deactivate(visibleViewConstraints)
        
        visibleViewConstraints = [
            visibleView.topAnchor.constraint(equalTo: view.topAnchor),
            visibleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visibleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visibleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardRect.size.height)
        ]
        
        NSLayoutConstraint.activate(visibleViewConstraints)
        visibleView.layoutIfNeeded()
        
        NSLayoutConstraint.deactivate(gitAlertConstraints)
        gitAlertConstraints = [
            gitAlertView.centerXAnchor.constraint(equalTo: visibleView.centerXAnchor),
            gitAlertView.centerYAnchor.constraint(equalTo: visibleView.centerYAnchor),
            gitAlertView.trailingAnchor.constraint(equalTo: visibleView.trailingAnchor, constant: -16),
            gitAlertView.leadingAnchor.constraint(equalTo: visibleView.leadingAnchor, constant: 16)
        ]
        
        if UIDevice.current.orientation.isLandscape {
            let topContraint = gitAlertView.topAnchor.constraint(equalTo: visibleView.topAnchor, constant: 16)
            topContraint.priority = UILayoutPriority(900)
            gitAlertConstraints.append(topContraint)
            
            let bottomConstraint = gitAlertView.bottomAnchor.constraint(equalTo: visibleView.bottomAnchor, constant: -16)
            bottomConstraint.priority = UILayoutPriority(900)
            gitAlertConstraints.append(bottomConstraint)
        }
        
        NSLayoutConstraint.activate(gitAlertConstraints)
        gitAlertView.layoutIfNeeded()
    }
}
