import UIKit

public protocol GitViewInterface: class {
    func showProgressHUD(view:UIView)
    func hideProgressHUD(view:UIView)
}

extension GitViewInterface {
    
    public func showProgressHUD(view:UIView) {
        GitProgressHUD.showAdded(to: view, animated: true)
    }
    
    public func hideProgressHUD(view:UIView) {
        GitProgressHUD.hide(for: view, animated: true)
    }
}
