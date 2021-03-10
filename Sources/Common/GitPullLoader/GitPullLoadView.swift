//
//  GitPullLoadView.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 15/04/2019.
//  Copyright © 2019 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/**
 Delegate for GitPullLoadView.
 */
public protocol GitPullLoadViewDelegate: class {
    /**
     Handler when GitPullLoaderState value changed.
     
     - parameter pullLoadView: GitPullLoadView.
     - parameter state:        New state.
     - parameter type:         GitPullLoaderType.
     */
    func pullLoadView(_ pullLoadView: GitPullLoadView, didChangeState state: GitPullLoaderState, viewType type: GitPullLoaderType)
}

/**
 Simple view which inherited GitPullLoadable protocol.
 This has only activity indicator and message label.
 */
open class GitPullLoadView: UIView, GitPullLoadable {
    
    private lazy var oneTimeSetUp: Void = { self.setUp() }()
    
    public let activityIndicator = UIActivityIndicatorView()
    public let messageLabel = UILabel()
    
    open weak var delegate: GitPullLoadViewDelegate?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        _ = oneTimeSetUp
    }
    
    // MARK: - Set up --------------
    open func setUp() {
        backgroundColor = .clear
        
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        addSubview(activityIndicator)
        
        messageLabel.font = .systemFont(ofSize: 10)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        addConstraints([
            NSLayoutConstraint(item: activityIndicator, attribute: .top, toItem: self, constant: 15.0),
            NSLayoutConstraint(item: activityIndicator, attribute: .centerX, toItem: self),
            NSLayoutConstraint(item: messageLabel, attribute: .top, toItem: self, constant: 40.0),
            NSLayoutConstraint(item: messageLabel, attribute: .centerX, toItem: self),
            NSLayoutConstraint(item: messageLabel, attribute: .bottom, toItem: self, constant: -15.0)
            ])
        
        messageLabel.addConstraint(
            NSLayoutConstraint(item: messageLabel, attribute: .width, relatedBy: .lessThanOrEqual, constant: 300)
        )
    }
    
    // MARK: - GitPullLoadable --------------
    open func didChangeState(_ state: GitPullLoaderState, viewType type: GitPullLoaderType) {
        switch state {
        case .none:
            activityIndicator.stopAnimating()
            
        case .pulling:
            break
            
        case .loading:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        delegate?.pullLoadView(self, didChangeState: state, viewType: type)
    }
}
