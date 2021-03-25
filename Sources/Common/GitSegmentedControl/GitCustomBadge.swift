//
//  CustomBadge.swift
//  testBadgeSegmentedControl
//
//  Created by Kelvin Leong on 25/03/2021.
//

import UIKit

open class GitCustomBadge: UIView{
    var badgeText:String
    var badgeTextColor:UIColor
    var badgeInsetColor:UIColor
    var badgeFrameColor:UIColor
    var badgeFrame:Bool
    var badgeShining:Bool
    var badgeCornerRoundness:CGFloat
    var badgeScaleFactor:CGFloat
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customBadge(withString badgeString:String) -> GitCustomBadge {
        return GitCustomBadge.init(withString: badgeString, withScale: 1.0, withShining: true)
    }
    
    func customBadge(withString badgeString:String, withStringColor stringColor:UIColor, withInsetColor insetColor:UIColor, withBadgeFrame badgeFrameYesNo:Bool, withBadgeFrameColor frameColor:UIColor, withScale scale:CGFloat, withShining shining:Bool) -> GitCustomBadge{
        return GitCustomBadge.init(withString: badgeString, withStringColor: stringColor, withInsetColor: insetColor, withBadgeFrame: badgeFrameYesNo, withBadgeFrameColor: badgeFrameColor, withScale: scale, withShining: shining)
    }
    
    init(withString badgeString:String, withScale scale:CGFloat, withShining shining:Bool) {
        
        self.badgeText = badgeString
        self.badgeTextColor = .white
        self.badgeFrame = true
        self.badgeFrameColor = .white
        self.badgeInsetColor = .red
        self.badgeCornerRoundness = 0.4
        self.badgeScaleFactor = scale
        self.badgeShining = shining
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        self.contentScaleFactor = UIScreen.main.scale
        self.backgroundColor = UIColor.clear
        self.autoBadgeSizeWithString(badgeString: badgeString)
    }
    
    init(withString badgeString:String, withStringColor stringColor:UIColor, withInsetColor insetColor:UIColor, withBadgeFrame badgeFrameYesNo:Bool, withBadgeFrameColor frameColor:UIColor, withScale scale:CGFloat, withShining shining:Bool) {
        
        self.badgeText = badgeString
        self.badgeTextColor = stringColor
        self.badgeFrame = badgeFrameYesNo
        self.badgeFrameColor = frameColor
        self.badgeInsetColor = insetColor
        self.badgeCornerRoundness = 0.4
        self.badgeScaleFactor = scale
        self.badgeShining = shining
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        self.contentScaleFactor = UIScreen.main.scale
        self.backgroundColor = UIColor.clear
        self.autoBadgeSizeWithString(badgeString: badgeString)
    }
    
    func autoBadgeSizeWithString(badgeString:String){
        var retValue:CGSize
        var rectWidth, rectHeight:CGFloat
        let stringSize:CGSize  = badgeString.sizeOfString(usingFont: UIFont.boldSystemFont(ofSize: 12))
        var flexSpace:CGFloat
        if badgeString.count >= 2 {
            flexSpace = CGFloat(badgeString.count)
            rectWidth = 15 + (stringSize.width + flexSpace); rectHeight = 25;
            retValue = CGSize(width: rectWidth*badgeScaleFactor, height: rectHeight*badgeScaleFactor);
        } else {
            retValue = CGSize(width: 25*badgeScaleFactor, height: 25*badgeScaleFactor);
        }
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: retValue.width, height: retValue.height);
        self.badgeText = badgeString;
        self.setNeedsDisplay()
    }
    
    

    func drawRoundedRectWithContext(context:CGContext, withRect rect:CGRect){
        context.saveGState()
        
        let radius:CGFloat = rect.maxY * self.badgeCornerRoundness
        let puffer:CGFloat = rect.maxY * 0.1
        let maxX:CGFloat = rect.maxX - puffer
        let maxY:CGFloat = rect.maxY - puffer
        let minX:CGFloat = rect.minX + puffer
        let minY:CGFloat = rect.minY + puffer
        
        context.beginPath()
        context.setFillColor(self.badgeInsetColor.cgColor)
        context.addArc(center: CGPoint.init(x: maxX-radius, y: minY+radius), radius: radius, startAngle: CGFloat(Double.pi+(Double.pi/2)), endAngle: 0, clockwise: false)
        context.addArc(center: CGPoint.init(x: maxX-radius, y: maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: false)
        context.addArc(center: CGPoint.init(x: minX+radius, y: maxY-radius), radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: false)
        context.addArc(center: CGPoint.init(x: minX+radius, y: minY+radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi+Double.pi/2), clockwise: false)
        context.setShadow(offset: CGSize.init(width: 1.0, height: 1.0), blur: 3, color: UIColor.black.cgColor)
        context.fillPath()
        context.restoreGState()
    }
    
    func drawShineWithContext(context:CGContext, withRect rect:CGRect){
        context.saveGState()
        
        let radius:CGFloat = rect.maxY * self.badgeCornerRoundness
        let puffer:CGFloat = rect.maxY * 0.1
        let maxX:CGFloat = rect.maxX - puffer
        let maxY:CGFloat = rect.maxY - puffer
        let minX:CGFloat = rect.minX + puffer
        let minY:CGFloat = rect.minY + puffer
        
        context.beginPath()
        context.addArc(center: CGPoint.init(x: maxX-radius, y: minY+radius), radius: radius, startAngle: CGFloat(Double.pi+(Double.pi/2)), endAngle: 0, clockwise: false)
        context.addArc(center: CGPoint.init(x: maxX-radius, y: maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: false)
        context.addArc(center: CGPoint.init(x: minX+radius, y: maxY-radius), radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: false)
        context.addArc(center: CGPoint.init(x: minX+radius, y: minY+radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi+Double.pi/2), clockwise: false)
        context.clip()
        
        let num_locations:size_t = 2
        let locations:Array<CGFloat> = [0.0, 0.4]
        let components:Array<CGFloat> = [0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4]
        var cspace:CGColorSpace
        var gradient:CGGradient
        cspace = CGColorSpaceCreateDeviceRGB()
        gradient = CGGradient.init(colorSpace: cspace, colorComponents: components, locations: locations, count: num_locations)!
        
        var sPoint, ePoint:CGPoint
        sPoint = CGPoint.init(x: 0, y: 0)
        ePoint = CGPoint.init(x: 0, y: 0)
        
        context.drawLinearGradient(gradient, start: sPoint, end: ePoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        context.restoreGState()
        
    }
    
    func drawFrameWithContext(context:CGContext, withRect rect:CGRect){
        let radius:CGFloat = rect.maxY * self.badgeCornerRoundness
        let puffer:CGFloat = rect.maxY * 0.1
        let maxX:CGFloat = rect.maxX - puffer
        let maxY:CGFloat = rect.maxY - puffer
        let minX:CGFloat = rect.minX + puffer
        let minY:CGFloat = rect.minY + puffer
        
        context.beginPath()
        var lineSize:CGFloat = CGFloat(2)
        if self.badgeScaleFactor > 1 {
            lineSize += self.badgeScaleFactor*0.25
        }
        context.setLineWidth(lineSize)
        context.setStrokeColor(self.badgeFrameColor.cgColor)
        context.addArc(center: CGPoint.init(x: maxX-radius, y: minY+radius), radius: radius, startAngle: CGFloat(Double.pi+(Double.pi/2)), endAngle: 0, clockwise: false)
        context.addArc(center: CGPoint.init(x: maxX-radius, y: maxY-radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: false)
        context.addArc(center: CGPoint.init(x: minX+radius, y: maxY-radius), radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: false)
        context.addArc(center: CGPoint.init(x: minX+radius, y: minY+radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi+Double.pi/2), clockwise: false)
        
        context.closePath()
        context.strokePath()
    }
    
    open override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!
        self.drawRoundedRectWithContext(context: context, withRect: rect)
        
        if self.badgeShining {
            self.drawShineWithContext(context: context, withRect: rect)
        }
        
        if self.badgeFrame {
            self.drawFrameWithContext(context: context, withRect: rect)
        }
        
        if self.badgeText.count > 0 {
            badgeTextColor.set()
            var sizeOfFont:CGFloat = 10 * badgeScaleFactor
            if self.badgeText.count < 2 {
                sizeOfFont += sizeOfFont*0.2
            }
            let textFont:UIFont = UIFont.boldSystemFont(ofSize: sizeOfFont)
            let textSize = self.badgeText.sizeOfString(usingFont: textFont)
            (self.badgeText as NSString).draw(at: CGPoint(x: rect.size.width/2 - textSize.width/2, y: rect.size.height/2 - textSize.height/2), withAttributes: [NSAttributedString.Key.font : textFont, NSAttributedString.Key.foregroundColor: badgeTextColor])
        }
    }
}

extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    
}

extension NSString {
    func drawWithBasePoint(basePoint: CGPoint, andAngle angle: CGFloat, andAttributes attributes: [NSAttributedString.Key: Any]) {
        let textSize: CGSize = self.size(withAttributes: attributes)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let t: CGAffineTransform = CGAffineTransform(translationX: basePoint.x, y: basePoint.y)
        let r: CGAffineTransform = CGAffineTransform(rotationAngle: angle)
        context.concatenate(t)
        context.concatenate(r)
        self.draw(at: CGPoint(x: textSize.width / 2, y: -textSize.height / 2), withAttributes: attributes)
        context.concatenate(r.inverted())
        context.concatenate(t.inverted())
    }
}
