//
//  extensions.swift
//  SFI
//
//  Created by OSX on 22/11/16.
//  Copyright © 2016 AppsMaven. All rights reserved.
//

import Foundation
import UIKit


///Custom View
@IBDesignable class CustomView: UIView
{
    @IBInspectable var cornerRadius: CGFloat = 0
        {
            didSet
            {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
                self.clipsToBounds = true
            }
    }
    @IBInspectable var borderWidth: CGFloat = 0
        {
            didSet
            {
                layer.borderWidth = borderWidth
            }
    }
    @IBInspectable var borderColor: UIColor?
        {
            didSet
            {
                layer.borderColor = borderColor?.cgColor
            }
    }
}

@IBDesignable class CustomImageView: UIImageView
{
    @IBInspectable var cornerRadius: CGFloat = 0
        {
            didSet
            {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
                self.clipsToBounds = true
            }
    }
    @IBInspectable var borderWidth: CGFloat = 0
        {
            didSet
            {
                layer.borderWidth = borderWidth
            }
    }
    @IBInspectable var borderColor: UIColor?
        {
            didSet
            {
                layer.borderColor = borderColor?.cgColor
            }
    }
}

@IBDesignable class CustomButton: UIButton
{
    @IBInspectable var cornerRadius: CGFloat = 0
        {
            didSet
            {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
                self.clipsToBounds = true
            }
       }
    @IBInspectable var borderColor: UIColor?
        {
        didSet
        {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0
        {
        didSet
        {
            layer.borderWidth = borderWidth
        }
    }

    
}

@IBDesignable class CustomLabel: UILabel
{
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet
        {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            self.clipsToBounds = true
        }
    }
   
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 10
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 10
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
//    override func intrinsicContentSize() -> CGSize {
//        var size = super.intrinsicContentSize
//        size.width += rightInset + leftInset
//        size.height += topInset + bottomInset
 //       return size
 //   }
}


extension UIColor {
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

typealias GradientType = (x: CGPoint, y: CGPoint)

enum GradientPoint {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    
    func draw() -> GradientType {
        switch self {
        case .leftRight:
            return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return (x: CGPoint(x: 0.5, y: 0), y: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
        }
    }
}

class GradientLayer : CAGradientLayer {
    var gradient: GradientType? {
        didSet {
            startPoint = gradient?.x ?? CGPoint.zero
            endPoint = gradient?.y ?? CGPoint.zero
        }
    }
}

class GradientView: UIView {
    override public class var layerClass: Swift.AnyClass {
        get {
            return GradientLayer.self
        }
    }
}

protocol GradientViewProvider {
    associatedtype GradientViewType
}

extension GradientViewProvider where Self: UIView, Self.GradientViewType: CAGradientLayer {
    var gradientLayer: Self.GradientViewType {
        return layer as! Self.GradientViewType
    }
}

extension UIView: GradientViewProvider {
    typealias GradientViewType = GradientLayer
}
