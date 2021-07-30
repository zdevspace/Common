//
//  ExtensionUINavigationBar.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
extension UINavigationBar {
    open func setTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    open func setMainTheme(gradientColor:[UIColor]) {
        self.tintColor = .white
        
        self.apply(gradient: gradientColor, alpha: 1.0)
        self.shadowImage = nil
        self.isTranslucent = false
    }
    
    open func setMainThemeWith(gradientColor:[UIColor], alpha: CGFloat) {
        self.tintColor = .white //Font color
        
        self.apply(gradient: gradientColor, alpha: min(0.99, alpha))
        
        self.shadowImage = UIImage()
        self.isTranslucent = true
        
        self.barStyle = .black
        self.subviews[0].alpha = 1
        self.barTintColor = UIColor.white
    }
    
    /// Applies a background gradient with the given colors
    open func apply(gradient colors : [UIColor], alpha: CGFloat) {
        var frameAndStatusBar: CGRect = self.bounds
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        frameAndStatusBar.size.height += height
        
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors)?.image(alpha: alpha), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static public func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.4, 0.6, 0.85, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
