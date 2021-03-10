//
//  GitAlertDimissTransitioning.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/// Class to build `GitAlertDimissTransitioning`
class GitAlertDimissTransitioning: BaseGitAlertTransitioning, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? GitAlert else {return}
        
        let gitAlertView = fromVC.gitAlertView 
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            self.buildGitAlertAnimation(gitAlertView: gitAlertView, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
            fromVC.view.backgroundColor = .clear
        }) { (finished) in
             transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
//            self.buildGitAlertAnimation(gitAlertView: gitAlertView, width: fromVC.view.bounds.size.width, height: fromVC.view.bounds.size.height)
//
//        }, completion: { (finished) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })
        
    }
}
