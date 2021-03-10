//
//  GitAlertPresentTransitioning.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/// Class to build `GitAlertPresentTransitioning`

class GitAlertPresentTransitioning: BaseGitAlertTransitioning, UIViewControllerAnimatedTransitioning {
    
    var originFrame = UIScreen.main.bounds
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? GitAlert else {return}
        
        toVC.view.frame = originFrame
        transitionContext.containerView.addSubview(toVC.view)
        
        let gitAlertView = toVC.gitAlertView
        buildGitAlertAnimation(gitAlertView: gitAlertView, width: toVC.view.bounds.size.width, height: toVC.view.bounds.size.height)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            gitAlertView.alpha = 1
            gitAlertView.transform = .identity
            toVC.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}
