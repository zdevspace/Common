//
//  GitActionCell.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/**
 GitActionCell.
 ```swift
 import GGITCommon
 ...
 @IBOutlet public var ivIcon: UIImageView!
 @IBOutlet public var lblActionTitle: UILabel!
 @IBOutlet public var lblBadge: UILabel!
 ```
 */
public class GitActionCell: UITableViewCell {

    @IBOutlet public var ivIcon: UIImageView!
    @IBOutlet public var lblActionTitle: UILabel!
    @IBOutlet public var lblBadge: UILabel!
    @IBOutlet weak var vwContent: UIView!
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
