//
//  GitActionBean.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/**
 GitActionBean.
 ```swift
 import GGITCommon
 ...
 public init(image:UIImage?, title:String, badge:Int?)
 ```
 */
public class GitActionBean: NSObject {

    public var image:UIImage? {
        didSet{
            self.hasImage = true
        }
    }
    public var title:String?
    public var badge:Int? {
        didSet{
            self.hasBadge = true
        }
    }
    
    public var hasImage = false
    public var hasBadge = false
    
    /**
     Action Bean object constructor.
     - Parameters:
        - image: The action bean image.
        - title: The action bean title.
        - badge: badge number
     
     ### Usage Example: ###
     ```swift
     import GGITCommon
     ...
     
     GitActionBean(image: nil, title: "Action Title", badge: nil)
     ```
     */
    public init(image:UIImage?, title:String, badge:Int?){
        if image != nil{
            self.image = image
            self.hasImage = true
        }
        
        self.title = title
        
        if badge != nil && badge != 0{
            self.badge = badge
            self.hasBadge = true
        }
    }
    
}
