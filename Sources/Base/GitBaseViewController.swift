//
//  GitBaseViewController.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit


/// Class to build `GitBaseViewController`
open class GitBaseViewController: UIViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Custom Method
    @objc open func setBackButtonTitleEmpty() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @objc open func setNavigationTitle(title: String){
        self.navigationItem.title = title
    }
    
     @objc open var preferredStatusBarStyleLightContent: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc open var preferredStatusBarStyleDefault: UIStatusBarStyle {
        return .default
    }
    
    @objc open func pushViewController(vc:GitBaseViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
