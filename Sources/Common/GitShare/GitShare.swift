//
//  GitShare.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 26/11/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension UIViewController {
    public func shareText(shareBean:GitShareBean){
        self.share(shareBean: shareBean, type: .text)
    }
    
    public func shareImage(shareBean:GitShareBean){
        self.share(shareBean: shareBean, type: .image)
    }
    
    public func shareUri(shareBean:GitShareBean){
        self.share(shareBean: shareBean, type: .uri)
    }
    
    public func shareAll(shareBean:GitShareBean){
        self.share(shareBean: shareBean, type: .default)
    }
    
    fileprivate func share(shareBean:GitShareBean, type:GitShareBean.GitShareType){
        var activityItems:Array<Any> = Array<Any>()
        switch type {
        case .text:
            activityItems.append(contentsOf: shareBean.text)
        case .image:
            activityItems.append(contentsOf: shareBean.image)
        case .uri:
            activityItems.append(contentsOf: shareBean.uri)
        default:
            activityItems.append(contentsOf: shareBean.text)
            activityItems.append(contentsOf: shareBean.image)
            activityItems.append(contentsOf: shareBean.uri)
        }
        
        print(activityItems)
        let ac = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        ac.excludedActivityTypes = shareBean.excludedActivityTypes
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
//                GitAlert.showAlert(vc: self, title: "Error", message: "Share to external failed.")
                return
            }
            // User completed activity
        }
        self.present(ac, animated: true)
    }
}
