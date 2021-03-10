//
//  ExtensionUIScrollView.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 15/04/2019.
//  Copyright © 2019 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

// MARK: - Public extensions ---------------
extension UIScrollView {
    /**
     Adds the PullLoadableView.
     
     - parameter loadView: view that contain GitPullLoadable.
     - parameter type:     GitPullLoaderType. Default type is `.refresh`.
     */
    func addPullLoadableView<T>(_ loadView: T, type: GitPullLoaderType = .refresh) where T: UIView, T: GitPullLoadable {
        let loader = GitPullLoader(loadView: loadView, type: type)
        insertSubview(loader, at: 0)
        loader.setUp()
    }
    
    /**
     Remove the PullLoadableView.
     
     - parameter loadView: view which inherited GitPullLoadable protocol.
     */
    public func removePullLoadableView<T>(_ loadView: T) where T: UIView, T: GitPullLoadable {
        loadView.removeFromSuperview()
    }
}

// MARK: - Internal extensions ---------------
extension UIScrollView {
    var distanceOffset: CGPoint {
        get {
            return CGPoint(
                x: contentOffset.x + contentInset.left,
                y: contentOffset.y + contentInset.top
            )
        }
        set {
            contentOffset = CGPoint(
                x: newValue.x - contentInset.left,
                y: newValue.y - contentInset.top
            )
        }
    }
    
    var distanceEndOffset: CGPoint {
        get {
            return CGPoint(
                x: (contentSize.width + contentInset.right) - (contentOffset.x + bounds.width),
                y: (contentSize.height + contentInset.bottom) - (contentOffset.y + bounds.height)
            )
        }
        set {
            contentOffset = CGPoint(
                x: newValue.x - (bounds.width - (contentSize.width + contentInset.right)),
                y: newValue.y - (bounds.height - (contentSize.height + contentInset.bottom))
            )
        }
    }
}
