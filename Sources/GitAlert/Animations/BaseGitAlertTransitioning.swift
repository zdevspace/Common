//
//  BaseGitAlertTransitioning.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//


import UIKit

/// Class to build `BaseGitAlertTransitioning`
class BaseGitAlertTransitioning: NSObject {
    
    var animationType: GitAlertAnimationType
    var duration: TimeInterval
    
    init(animationType: GitAlertAnimationType, duration: TimeInterval) {
        self.animationType = animationType
        self.duration = duration
        super.init()
    }
    
    func buildGitAlertAnimation(gitAlertView: UIView, width: CGFloat, height: CGFloat) {
        switch animationType {
        case .modalBottom:
            gitAlertView.transform = CGAffineTransform.init(translationX: 0, y: height)
            break
            
        case .modalLeft:
            gitAlertView.transform = CGAffineTransform.init(translationX: -width, y: 0)
            break
            
        case .modalRight:
            gitAlertView.transform = CGAffineTransform.init(translationX: width, y: 0)
            break
            
        case .fadeIn:
            gitAlertView.alpha = 0
            break
        }
    }
}
