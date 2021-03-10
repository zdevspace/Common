//
//  ExtensionUITableView.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit
import Foundation

func customAssociatedObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}
func customAssociateObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}
public protocol TableViewRefreshControlDelegate {
    func tableView(_ tableView: UITableView, didEndRefreshControl type:GitPullLoaderType?)
}

/**
 TableViewRefreshControl.
 ```swift
 import GGITCommon
 ...
 @objc func refresh(sender:AnyObject)
 ```
 */
open class TableViewRefreshControl: NSObject { // Every Miller should have a Cat
    var tableViewRefreshControlDelegate:TableViewRefreshControlDelegate?
    var tableView:UITableView?
    var footerView:GitPullLoadView
    var type:GitPullLoaderType?
    var isLoading:Bool = false {
        didSet{
            if isLoading {
                footerView.isHidden = false
            }else{
                footerView.isHidden = true
            }
        }
    }
    
    typealias FooterGitPullRefreshCompletionHandler = ()->Void
    var footerGitPullRefreshCompletionHandler:FooterGitPullRefreshCompletionHandler?
    
    override init() {
        footerView = GitPullLoadView()
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            if self.tableViewRefreshControlDelegate != nil {
                self.isLoading = true
                self.tableViewRefreshControlDelegate?.tableView(self.tableView!, didEndRefreshControl: .refresh)
            }
        })
    }
    
    func addFooterRefresh(){
        footerView = GitPullLoadView()
        footerView.delegate = self
        tableView?.addPullLoadableView(footerView, type: .loadMore)
    }
    
    func hideFooterRefresh(){
        footerGitPullRefreshCompletionHandler?()
    }
}

extension TableViewRefreshControl: GitPullLoadViewDelegate{
    public func pullLoadView(_ pullLoadView: GitPullLoadView, didChangeState state: GitPullLoaderState, viewType type: GitPullLoaderType) {
        switch type {
        case .loadMore:
            switch state {
            case let .loading(completionHandler: footerCompletion):
                footerGitPullRefreshCompletionHandler = footerCompletion
                if !self.isLoading {
                    self.isLoading = true
                    self.tableViewRefreshControlDelegate?.tableView(self.tableView!, didEndRefreshControl: .loadMore)
                }
            case .none:
                break
            case .pulling(let offset, let threshold):
                break
            }
        default:
            break
        }
    }
    
    
}

private var tableViewRefreshControlKey: UInt8 = 0
extension UITableView {
    open var tableViewRefreshControl: TableViewRefreshControl { // cat is *effectively* a stored property
        get {
            return customAssociatedObject(base: self, key: &tableViewRefreshControlKey )
            { return TableViewRefreshControl() } // Set the initial value of the var
        }
        set { customAssociateObject(base: self, key: &tableViewRefreshControlKey , value: newValue) }
    }
    
    open func showLoadingRefresh(tableViewRefreshControlDelegate:TableViewRefreshControlDelegate, color:UIColor? = nil){
        self.tableViewRefreshControl.tableView = self
        self.tableViewRefreshControl.tableViewRefreshControlDelegate = tableViewRefreshControlDelegate
        
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self.tableViewRefreshControl, action: #selector(self.tableViewRefreshControl.refresh(sender:)), for: UIControl.Event.valueChanged)
        if color != nil{
            refreshControl.tintColor = color
        }
        self.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    open func hideLoadingRefresh(){
        for view in self.subviews {
            if view is UIRefreshControl {
                self.tableViewRefreshControl.isLoading = false
                (view as! UIRefreshControl).endRefreshing()
            }
        }
    }
    
    open func showLoadingLoadMore(tableViewRefreshControlDelegate:TableViewRefreshControlDelegate){
        self.tableViewRefreshControl.tableView = self
        self.tableViewRefreshControl.tableViewRefreshControlDelegate = tableViewRefreshControlDelegate
        self.tableViewRefreshControl.addFooterRefresh()
    }
    
    open func hideLoadingLoadMore(){
        self.tableViewRefreshControl.isLoading = false
        self.tableViewRefreshControl.hideFooterRefresh()
    }
    
    open func setLoadMoreLabelMessage(message:String){
        self.tableViewRefreshControl.footerView.messageLabel.text = message
    }
    
}
