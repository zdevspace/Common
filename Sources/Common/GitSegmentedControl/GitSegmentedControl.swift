//
//  MeSegmentedControl.swift
//  testBadgeSegmentedControl
//
//  Created by Kelvin Leong on 25/03/2021.
//

import UIKit

open class GitSegementedControl: UISegmentedControl {
    private var _segmentBadgeNumbers:NSMutableArray = []
    private var _segmentBadges:NSMutableArray = []
    private var _badgeView:UIView?
    
    
    func setBadgeNumber(badgeNumber: Int, forSegmentAtIndex segmentIndex: Int, configureBadge: ((GitCustomBadge?) -> ())?) {
        if _segmentBadgeNumbers.count == 0 {
            _segmentBadgeNumbers = NSMutableArray(capacity: self.numberOfSegments)
            for _ in 0...self.numberOfSegments {
                _segmentBadgeNumbers.add(NSNumber.init(value: 0))
                _segmentBadges.add(NSNull.init())
            }
            
            _badgeView = UIView.init(frame: self.frame)
            _badgeView?.backgroundColor = .clear
            _badgeView?.isUserInteractionEnabled = false
            self.superview?.addSubview(_badgeView ?? UIView())
        }
        
        let oldBadgeNumber:Int = _segmentBadgeNumbers.object(at: segmentIndex) as! Int
        _segmentBadgeNumbers.replaceObject(at: segmentIndex, with: badgeNumber)
        
        if oldBadgeNumber == 0 && badgeNumber > 0 {
            let customBadge:GitCustomBadge = GitCustomBadge.init(withString: "\(badgeNumber)", withScale: 1.0, withShining: true)
            let x:CGFloat = CGFloat(((Int(self.frame.size.width)/self.numberOfSegments) * (segmentIndex + 1))) - customBadge.frame.size.width + 5
            let rect:CGRect = CGRect(x: x-5, y: -5, width: customBadge.frame.size.width, height: customBadge.frame.size.height)
            customBadge.frame = rect
            _segmentBadges.replaceObject(at: segmentIndex, with: customBadge)
            _badgeView?.addSubview(customBadge)
        }else if oldBadgeNumber > 0 && badgeNumber == 0 {
            if let view:GitCustomBadge = _segmentBadges.object(at: segmentIndex) as? GitCustomBadge {
                view.removeFromSuperview()
            }
            _segmentBadges.replaceObject(at: segmentIndex, with: NSNull.init())
        }else if oldBadgeNumber != badgeNumber && badgeNumber > 0 {
            if let view:GitCustomBadge = _segmentBadges.object(at: segmentIndex) as? GitCustomBadge {
                view.autoBadgeSizeWithString(badgeString: "\(badgeNumber)")
            }
        }
        
        if badgeNumber > 0 {
            configureBadge?(_segmentBadges.object(at: segmentIndex) as? GitCustomBadge)
        }
    }
    
    func setBadgeNumber(badgeNumber:Int, forSegmentAtInde segmentIndex:Int){
        self.setBadgeNumber(badgeNumber: badgeNumber, forSegmentAtIndex: segmentIndex, configureBadge: nil)
    }
    
    func getBadgeNumberForSegmentAtIndex(segmentIndex:Int) -> Int {
        if _segmentBadgeNumbers.count <= 0 {
            return 0;
        }
        
        if let number: Int = _segmentBadgeNumbers.object(at: segmentIndex) as? Int {
            if number > 0{
                return number
            }else {
                return 0
            }
        }else{
            return 0
        }
    }
    
    func clearBadges(){
        _badgeView?.removeFromSuperview()
        _segmentBadges.removeAllObjects()
        _segmentBadgeNumbers.removeAllObjects()
    }
    
}
