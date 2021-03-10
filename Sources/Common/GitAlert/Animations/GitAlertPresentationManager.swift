//
//  GitAlertPresentationManager.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/// Enum `GitAlertAnimationType`
public enum GitAlertAnimationType {
    case modalBottom
    case modalLeft
    case modalRight
    case fadeIn
}

/// Class to build `GitAlertPresentationManager`
class GitAlertPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var animationType: GitAlertAnimationType = .modalBottom
    var presentDuration: TimeInterval = 0.5
    var dismissDuration: TimeInterval = 0.3
    
    var interactor: GitAlertInteractiveTransition?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GitAlertPresentTransitioning(animationType: self.animationType, duration: presentDuration)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GitAlertDimissTransitioning(animationType: self.animationType, duration: dismissDuration)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let interactor = interactor {
            return interactor.hasStarted ? interactor : nil
        }
        return nil
    }
}
