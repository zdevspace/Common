//
//  ExtensionUICollectionView.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit
import Foundation

@objc public protocol CollectionViewRefreshControlDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, didEndRefreshControl error: Error?)
}

/**
 CollectionViewRefreshControl.
 ```swift
 import GGITCommon
 ...
 @objc func refresh(sender:AnyObject)
 ```
 */
open class CollectionViewRefreshControl: NSObject { // Every Miller should have a Cat
    var collectionViewRefreshControlDelegate:CollectionViewRefreshControlDelegate?
    var collectionView:UICollectionView?
    
    override init() {
        super.init()
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        print("refresh")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            if self.collectionViewRefreshControlDelegate != nil {
                self.collectionViewRefreshControlDelegate?.collectionView!(self.collectionView!, didEndRefreshControl: nil)
            }
        })
        
    }
}

private var collectionViewRefreshControlKey: UInt8 = 0
extension UICollectionView {
    open var collectionViewRefreshControl: CollectionViewRefreshControl { // cat is *effectively* a stored property
        get {
            return customAssociatedObject(base: self, key: &collectionViewRefreshControlKey )
            { return CollectionViewRefreshControl() } // Set the initial value of the var
        }
        set { customAssociateObject(base: self, key: &collectionViewRefreshControlKey , value: newValue) }
    }
    
    open func showLoadingHeader(collectionViewRefreshControlDelegate:CollectionViewRefreshControlDelegate){
        self.collectionViewRefreshControl.collectionView = self
        self.collectionViewRefreshControl.collectionViewRefreshControlDelegate = collectionViewRefreshControlDelegate
        
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self.collectionViewRefreshControl, action: #selector(self.collectionViewRefreshControl.refresh(sender:)), for: UIControl.Event.valueChanged)
        self.addSubview(refreshControl)
    }
    
    open func hideLoadingHeader(){
        for view in self.subviews {
            if view is UIRefreshControl {
                (view as! UIRefreshControl).endRefreshing()
            }
        }
    }
}
