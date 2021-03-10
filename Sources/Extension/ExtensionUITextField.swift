//
//  ExtensionUITextField.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 14/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

@IBDesignable
public class DesignableUITextField: UITextField{
    
}

public extension UITextField{
    
    //For Login Title
    @objc public func setAttributedFont(){
        #if swift(>=4.2)
        let attributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : self.font!
        ]
        #else
        let attributes:[NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font : self.font!
        ]
        #endif
        
        var placeHolder = NSMutableAttributedString()
        placeHolder = NSMutableAttributedString(string:self.placeholder!, attributes: attributes)

        self.attributedPlaceholder = placeHolder
    }
    
    @objc public func setAttributedFont_Red(){

        #if swift(>=4.2)
        let attributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font : self.font!
        ]
        #else
        let attributes:[NSAttributedStringKey : Any] = [
        NSAttributedStringKey.foregroundColor: UIColor.red,
        NSAttributedStringKey.font : self.font!
        ]
        #endif
        
        var placeHolder = NSMutableAttributedString()
        placeHolder = NSMutableAttributedString(string:self.placeholder!, attributes: attributes)
        
        self.attributedPlaceholder = placeHolder
    }
    
    func paddingLeft(leftpadding: CGFloat) -> UITextField {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftpadding, height: self.frame.size.height))
        self.leftViewMode = UITextField.ViewMode .always
        return self
    }
    
    func placeholderWarning(warning : String) -> UITextField {
        self.attributedPlaceholder = NSAttributedString(string:warning, attributes:[NSAttributedString.Key.foregroundColor: UIColor.red])
        return self
    }
    
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        let width = 50
        let height = width
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: Double(exactly: width/2)!, height: Double(exactly: width/2)!)
        view.addSubview(imageView)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: height)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: height)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
}
