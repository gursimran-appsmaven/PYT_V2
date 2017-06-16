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


