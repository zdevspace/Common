//
//  GitShareBean.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 26/11/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import Foundation
import UIKit

public class GitShareBean {
    public var text:Array<String> = Array<String>()
    public var image:Array<UIImage> = Array<UIImage>()
    public var uri:Array<URL> = Array<URL>()
    public var excludedActivityTypes:Array<UIActivity.ActivityType> = Array<UIActivity.ActivityType>()
    
    public enum GitShareType {
        case `text`
        case `image`
        case `uri`
        case `default`
    }
    
    public init() { }
    public func appendText(text:String) {
        self.text.append(text)
    }
    
    public func appendText(texts:Array<String>) {
        self.text.append(contentsOf: texts)
    }
    
    public func appendImage(image:UIImage){
        self.image.append(image)
    }
    
    public func appendImage(images:Array<UIImage>){
        self.image.append(contentsOf: images)
    }
    
    public func appendUri(uri:URL) {
        self.uri.append(uri)
    }
    
    public func appendUri(uri:Array<URL>) {
        self.uri.append(contentsOf: uri)
    }
    
    public func appendExcludedActivityTypes(activityType:UIActivity.ActivityType){
        self.excludedActivityTypes.append(activityType)
    }
    
    public func appendExcludedActivityTypes(activityTypes:Array<UIActivity.ActivityType>){
        self.excludedActivityTypes.append(contentsOf: activityTypes)
    }
}
