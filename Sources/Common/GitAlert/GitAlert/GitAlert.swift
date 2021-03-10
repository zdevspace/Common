//
//  GitAlert.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

/// Class to build `GitAlert`
public class GitAlert: GitAlertBaseViewController {
    
    // MARK: - private
    private let gitAlertPresentationManager = GitAlertPresentationManager()
    
    // MARK: - internal
    let gitAlertView: GitAlertView
    var gitAlertConstraints: [NSLayoutConstraint] = []
    var visibleViewConstraints: [NSLayoutConstraint] = []
    
    let tapToDismiss: Bool
    let dismissOnActionTapped: Bool
    
    lazy var visibleView: UIView = {
        let visibleView = UIView()
        visibleView.translatesAutoresizingMaskIntoConstraints = false
        return visibleView
    }()
    
    public class func showAlert(vc:UIViewController, title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true) {}
    }
    
    public class func showAlert(vc:UIViewController, title:String, message:String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        vc.present(alert, animated: true) {}
    }
    
    public class func showAlert(vc:UIViewController, title:String, message:String, actionTitle:String, actionHandler:((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        vc.present(alert, animated: true) {}
    }
    
    public class func showAlert(vc:UIViewController, title:String, message:String, positiveActionTitle:String, positiveActionHandler:((UIAlertAction) -> Void)? = nil, negativeActionTitle:String, negativeActionHandler:((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveActionTitle, style: .default, handler: positiveActionHandler))
        alert.addAction(UIAlertAction(title: negativeActionTitle, style: .cancel, handler: negativeActionHandler))
        vc.present(alert, animated: true) {}
    }
    
    /// Constructor for the GitAlert
    ///
    /// - Parameters:
    ///   - title: alert title
    ///   - customView: alert custom view
    ///   - tapToDismiss: tapToDismiss
    ///   - dismissOnActionTapped: dismissOnActionTapped
    public init(title: String? = nil, customView: UIView? = nil, tapToDismiss: Bool = true, dismissOnActionTapped: Bool = true) {
        self.gitAlertView = GitAlertView()
        self.tapToDismiss = tapToDismiss
        self.dismissOnActionTapped = dismissOnActionTapped
        super.init(nibName: nil, bundle: nil)
        
        self.gitAlertView.seTitle(title)
        self.gitAlertView.setCustomView(customView)
        
        self.animationType = .modalBottom
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = gitAlertPresentationManager
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    override public func loadView() {
        super.loadView()
        
        gitAlertView.alpha = 1
        gitAlertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visibleView)
        visibleView.addSubview(gitAlertView)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        listenKeyboard()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeContraints()
    }
    
    override func keyboardWillShow(sender: NSNotification) {
        super.keyboardWillShow(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    override func keyboardWillHide(sender: NSNotification) {
        super.keyboardWillHide(sender: sender)
        self.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    deinit {
        print("dealloc ---> GitAlert")
    }
}

extension GitAlert {
    
    /* Animation config */
    public var animationType: GitAlertAnimationType  {
        get { return gitAlertPresentationManager.animationType }
        set { gitAlertPresentationManager.animationType = newValue }
    }
    
    public var presentDuration: TimeInterval {
        get { return gitAlertPresentationManager.presentDuration }
        set { gitAlertPresentationManager.presentDuration = newValue }
    }
    
    public var dismissDuration: TimeInterval {
        get { return gitAlertPresentationManager.dismissDuration }
        set { gitAlertPresentationManager.dismissDuration = newValue }
    }
    
    /* Container config */
    public var margin: CGFloat {
        get { return gitAlertView.margin }
        set { gitAlertView.margin = newValue }
    }
    
    public var cornerRadius: CGFloat {
        get { return gitAlertView.cornerRadius }
        set { gitAlertView.cornerRadius = newValue }
    }
    
    public var backgroundColor: UIColor? {
        get { return gitAlertView.backgroundColor }
        set { gitAlertView.backgroundColor = newValue }
    }
    
    /* Title config */
    public var textColor: UIColor {
        get { return gitAlertView.textColor }
        set { gitAlertView.textColor = newValue }
    }
    
    public var textAlign: NSTextAlignment {
        get { return gitAlertView.textAlign }
        set { gitAlertView.textAlign = newValue }
    }
    
    public var titleFont: UIFont {
        get { return gitAlertView.titleFont }
        set { gitAlertView.titleFont = newValue }
    }
    
    /* Buttons config */
    public var buttonsHeight: CGFloat {
        get { return gitAlertView.buttonsHeight }
        set { gitAlertView.buttonsHeight = newValue }
    }
    
    public var separetorColor: UIColor {
        get { return gitAlertView.separetorColor }
        set { gitAlertView.separetorColor = newValue }
    }
    
    public var buttonsSpace: CGFloat {
        get { return gitAlertView.buttonsSpace }
        set { gitAlertView.buttonsSpace = newValue }
    }
    
    public var buttonsSideMargin: CGFloat {
        get { return gitAlertView.buttonsSideMargin }
        set { gitAlertView.buttonsSideMargin = newValue }
    }

    public var buttonsBottomMargin: CGFloat {
        get { return gitAlertView.buttonsBottomMargin }
        set { gitAlertView.buttonsBottomMargin = newValue }
    }
    
    public var buttonsAxis: NSLayoutConstraint.Axis {
        get { return gitAlertView.buttonsAxis }
        set { gitAlertView.buttonsAxis = newValue }
    }
    
    public func addAction(_ gitAlertButton: GitAlertAction) {
        gitAlertView.addButton(gitAlertButton, actionCallback: self)
    }
}
