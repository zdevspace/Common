//
//  TableFooterView.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/// Class to build `TableFooterView`
open class TableFooterView: UIView {
    @IBOutlet open var loadingView: UIActivityIndicatorView!
    
    @IBOutlet open var lblFooter: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
      
    }

}
