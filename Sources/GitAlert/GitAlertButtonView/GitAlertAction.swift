//
//  GitAlertAction.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//


import UIKit

/// Class to build `GitAlertAction`
public class GitAlertAction {
    
    public var title: String
    public var actionBlock: (() -> ())?

    public var tintColor: UIColor?
    public var backgroundColor: UIColor?
    public var cornerRadius: CGFloat?
    public var borderColor: UIColor?
    public var borderWidth: CGFloat?
    
    public init(title: String, actionBlock: (() -> ())? = nil) {
        self.title = title
        self.actionBlock = actionBlock
    }
    
    public init(title: String, backgroundColor: UIColor, actionBlock: (() -> ())? = nil) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.actionBlock = actionBlock
    }
}
