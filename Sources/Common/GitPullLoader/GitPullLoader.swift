//
//  GitPullLoader.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 15/04/2019.
//  Copyright © 2019 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/**
 Type of GitPullLoader's position.
 
 - refresh:  At the head of UIScrollView's scroll direction
 - loadMore: At the tail of UIScrollView's scroll direction
 */
@objc public enum GitPullLoaderType:Int {
    case refresh, loadMore
}

/**
 State of GitPullLoader
 
 - none:    hides the view.
 - pulling: Pulling.
 `offset` is pull offset (always <= 0).
 This state changes to `loading` when `offset` exceeded `threshold`.
 - loading: Shows the view.
 You should call `completionHandler` when some actions have been completed.
 */
public enum GitPullLoaderState: Equatable {
    case none
    case pulling(offset: CGPoint, threshold: CGFloat)
    case loading(completionHandler: ()->Void)
    
    public static func == (lhs: GitPullLoaderState, rhs: GitPullLoaderState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.loading, .loading): return true
        case let (.pulling(lOffset, lThreshold), .pulling(rOffset, rThreshold)):
            return lOffset == rOffset && lThreshold == rThreshold
        default: return false
        }
    }
}

/**
 GitPullLoadable is a protocol for views added to UIScrollView.
 */
public protocol GitPullLoadable: class {
    /**
     Handler when GitPullLoaderState value changed.
     
     - parameter state: New state.
     - parameter type:  GitPullLoaderType.
     */
    func didChangeState(_ state: GitPullLoaderState, viewType type: GitPullLoaderType)
}

class GitPullLoader<T>: UIView where T: UIView, T: GitPullLoadable {
    
    private lazy var setUpLayoutConstraints: Void = { self.adjustLayoutConstraints() }()
    
    private var observations = [NSKeyValueObservation]()
    private var defaultInset = UIEdgeInsets()
    private var scrollDirectionPositionConstraint: NSLayoutConstraint?
    
    let loadView: T
    let type: GitPullLoaderType
    
    var scrollView: UIScrollView? {
        return superview as? UIScrollView
    }
    
    var scrollDirection: UICollectionView.ScrollDirection {
        return ((superview as? UICollectionView)?.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection ?? .vertical
    }
    
    var state = GitPullLoaderState.none {
        didSet {
            loadView.didChangeState(state, viewType: type)
        }
    }
    
    init(loadView: T, type: GitPullLoaderType) {
        self.loadView = loadView
        self.type = type
        super.init(frame: loadView.bounds)
        addSubview(loadView)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = setUpLayoutConstraints
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        guard subview == loadView else { return }
        observations = []
    }
}

// MARK: - Actions -------------------
extension GitPullLoader {
    func setUp() {
        checkScrollViewContentSize()
        addObservers()
    }
}

// MARK: - Private Actions -------------------
private extension GitPullLoader {
    func addObservers() {
        guard let scrollView = self.scrollView else { return }
        
        let contentOffsetObservation = scrollView.observe(\.contentOffset) { _, _ in
            if case .loading = self.state { return }
            if self.isHidden { return }
            self.updateState()
        }
        
        let contentSizeObservation = scrollView.observe(\.contentSize) { _, _ in
            if case .loading = self.state { return }
            self.checkScrollViewContentSize()
        }
        
        observations = [contentOffsetObservation, contentSizeObservation]
    }
    
    func updateState() {
        guard let scrollView = scrollView else { return }
        
        let offset = (type == .refresh) ? scrollView.distanceOffset : scrollView.distanceEndOffset
        let offsetValue = (scrollDirection == .vertical) ? offset.y : offset.x
        let threshold = (scrollDirection == .vertical) ? bounds.height : bounds.width
        
        if scrollView.isDecelerating && offsetValue < -threshold {
            state = .loading(completionHandler: endLoading)
            startLoading()
        } else if offsetValue < 0 {
            state = .pulling(offset: offset, threshold: -(threshold + 12))
        } else if state != .none {
            state = .none
        }
    }
}

// MARK: - Layouts -------------------
private extension GitPullLoader {
    func checkScrollViewContentSize() {
        if type == .refresh { return }
        guard let scrollView = scrollView, let constraint = scrollDirectionPositionConstraint else { return }
        self.isHidden = scrollView.bounds.height > (scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom)
        constraint.constant = (scrollDirection == .vertical) ?
            scrollView.contentSize.height + scrollView.contentInset.bottom :
            scrollView.contentSize.width + scrollView.contentInset.right
    }
    
    func adjustLayoutConstraints() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        loadView.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .left, .right, .bottom]
        addConstraints(attributes.map { NSLayoutConstraint(item: loadView, attribute: $0, toItem: self) })
        
        scrollDirection == .vertical ? adjustVerticalScrollLayoutConstraints() : adjustHorizontalScrollLayoutConstraints()
    }
    
    func adjustVerticalScrollLayoutConstraints() {
        guard let scrollView = scrollView else { return }
        
        switch type {
        case .refresh:
            scrollDirectionPositionConstraint = NSLayoutConstraint(item: self, attribute: .bottom, toItem: scrollView, attribute: .top, constant: -scrollView.contentInset.top)
        case .loadMore:
            let constant = scrollView.contentSize.height + scrollView.contentInset.bottom
            scrollDirectionPositionConstraint = NSLayoutConstraint(item: self, attribute: .top, toItem: scrollView, attribute: .top, constant: constant)
        }
        
        scrollView.addConstraints([
            scrollDirectionPositionConstraint!,
            NSLayoutConstraint(item: self, attribute: .centerX, toItem: scrollView),
            NSLayoutConstraint(item: self, attribute: .width, toItem: scrollView)
            ])
    }
    
    func adjustHorizontalScrollLayoutConstraints() {
        guard let scrollView = scrollView else { return }
        
        switch type {
        case .refresh:
            let constant = -scrollView.contentInset.left
            scrollDirectionPositionConstraint = NSLayoutConstraint(item: self, attribute: .right, toItem: scrollView, attribute: .left, constant: constant)
        case .loadMore:
            let constant = scrollView.contentSize.width + scrollView.contentInset.right
            scrollDirectionPositionConstraint = NSLayoutConstraint(item: self, attribute: .left, toItem: scrollView, attribute: .left, constant: constant)
        }
        
        scrollView.addConstraints([
            scrollDirectionPositionConstraint!,
            NSLayoutConstraint(item: self, attribute: .centerY, toItem: scrollView),
            NSLayoutConstraint(item: self, attribute: .height, toItem: scrollView)
            ])
    }
}

// MARK: - Loading actions -------------------
private extension GitPullLoader {
    func startLoading() {
        guard case .loading = state, let scrollView = self.scrollView else { return }
        defaultInset = scrollView.contentInset
        animateScrollViewInset(isShow: true)
    }
    
    func endLoading() {
        state = .none
        animateScrollViewInset(isShow: false)
    }
    
    func animateScrollViewInset(isShow: Bool) {
        guard let scrollView = self.scrollView else { return }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            switch (self.scrollDirection, self.type) {
            case (.vertical, .refresh):
                scrollView.contentInset.top = self.defaultInset.top + (isShow ? self.bounds.height : 0)
            case (.vertical, .loadMore):
                scrollView.contentInset.bottom = self.defaultInset.bottom + (isShow ? self.bounds.height : 0)
            case (.horizontal, .refresh):
                scrollView.contentInset.left = self.defaultInset.left + (isShow ? self.bounds.width : 0)
            case (.horizontal, .loadMore):
                scrollView.contentInset.right = self.defaultInset.right + (isShow ? self.bounds.width : 0)
            case (_, _):
                break
            }
        }, completion: nil)
    }
}
