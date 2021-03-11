//
//  GitAlertController.swift
//  CustomAlertController
//
//  Created by Kelvin Leong on 09/11/2017.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

@objc public protocol GitAlertControllerDelegate {
    @objc optional func gitAlertController(_ gitAlertController:GitAlertController, didSelectRowAt row:Int)
}

/**
 GitAlertController.
 ```swift
 import GGITCommon
 ...
 public var arrGitActionBean:Array<GitActionBean>?
 public var delegate: GitAlertControllerDelegate?
 ```
 */
public class GitAlertController: UIAlertController, UITableViewDataSource, UITableViewDelegate {
    
    private var controller : UITableViewController
    public var arrGitActionBean:Array<GitActionBean>? {
        didSet {
            controller.tableView.reloadData()
        }
    }
    public var delegate: GitAlertControllerDelegate?
    public var cellBackgroundColor:UIColor?
    public var cellTextColor:UIColor?
    public var tableViewBackgroundColor: UIColor? {
        didSet {
            controller.tableView.backgroundColor = self.tableViewBackgroundColor
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        controller = UITableViewController(style: .plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        controller.tableView.register(UINib.init(nibName: "GitActionCell", bundle: Bundle.module), forCellReuseIdentifier: "GitActionCell")
        controller.tableView.dataSource = self
        controller.tableView.delegate = self
        controller.tableView.bounces = false
        if #available(iOS 13.0, *) {
            setBackgroundColor(color: .secondarySystemGroupedBackground)
            controller.tableView.backgroundColor = .secondarySystemGroupedBackground
            cellBackgroundColor = .secondarySystemGroupedBackground
            cellTextColor = .black
        } else {
            let color = UIColor(red: 28.0, green: 28.0, blue: 30.0, alpha: 1.0)
            setBackgroundColor(color: color)
            controller.tableView.backgroundColor = color
            cellBackgroundColor = color
            cellTextColor = .black
        }

        if #available(iOS 11.0, *) {
            controller.tableView.contentInsetAdjustmentBehavior = .never
        }
        controller.tableView.addObserver(self, forKeyPath: "contentSize", options: [.initial, .new], context: nil)
        self.setValue(controller, forKey: "contentViewController")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize" else {
            return
        }
        
        controller.preferredContentSize = controller.tableView.contentSize
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        controller.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard arrGitActionBean != nil else { return 0 }
        return (arrGitActionBean?.count)!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GitActionCell", for: indexPath) as! GitActionCell
        
        if (arrGitActionBean?[indexPath.row].hasImage)! {
            cell.ivIcon.isHidden = false
            cell.ivIcon.image = arrGitActionBean?[indexPath.row].image
        }else{
            cell.ivIcon.isHidden = true
        }
        cell.lblActionTitle.text = arrGitActionBean?[indexPath.row].title
        cell.lblActionTitle.textColor = cellTextColor
        if (arrGitActionBean?[indexPath.row].hasBadge)! {
            cell.lblBadge.isHidden = false
            cell.lblBadge.text = String.init(describing: (arrGitActionBean?[indexPath.row].badge)!)
        }else{
            cell.lblBadge.isHidden = true
        }
        
        if cellBackgroundColor != nil {
            cell.vwContent.backgroundColor = cellBackgroundColor
            cell.backgroundColor = cellBackgroundColor
        } else {
            cell.vwContent.backgroundColor = cellBackgroundColor
            cell.backgroundColor = cellBackgroundColor
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.gitAlertController!(self, didSelectRowAt: indexPath.row)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
}

extension GitAlertController {
    /**
     GitAlertController set background color.
     - Parameters:
     - color: The background color.
     
     ### Usage Example: ###
     ```swift
     import GGITCommon
     ...
     
     gitAlertController.setBackgroundColor(color: .white)
     ```
     */
    public func setBackgroundColor(color:UIColor){
        //        (self.view.subviews.first)?.subviews.first?.backgroundColor = color
        (self.view.subviews.first)?.subviews.first?.subviews.first?.subviews.first?.subviews.first?.backgroundColor = color
    }
    
    public func setTableViewBackgroundColor(color: UIColor) {
        controller.tableView.backgroundColor = color
    }
    
    public func setTableViewCellBackgroundColor(color: UIColor) {
        self.cellBackgroundColor = color
    }
    
    public func setTableViewCellTextColor(color:UIColor){
        self.cellTextColor = color
    }
}
