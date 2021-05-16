//
//  HelperClass.swift
//  FoodAppDemo
//
//  Created by Aakash Uppal on 16/05/21.
//  Copyright © 2021 Aakash Uppal. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func setImage(_ str : String, placeholder : UIImage? = UIImage()) {
        let completeUrl = str
        let url = URL(string: completeUrl.replacingOccurrences(of: " ", with: "%20"))
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholder, options: .continueInBackground, context: nil)
    }
}

extension UIViewController {
    func showAlert(message: String ,strtitle: String, handler:((UIAlertAction) -> Void)! = nil) {
        let alert = UIAlertController(title: strtitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func encodeFavouriteData(data:[Meals]) {
        let encoder = JSONEncoder()
        do {
            let obj = try encoder.encode(data)
            Constant.userDefault.set(obj, forKey: "favouriteMeals")
            Constant.favouriteMeals = data
        }
        catch let error {
            print("Some Error is \(error)")
        }
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var roundCorners: Bool {
        get {
            return false
        }
        set {
            layer.cornerRadius = newValue == true ? self.frame.height / 2 : 0.0
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var boarderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable
    var shadowOffset: CGSize{
        get{
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float{
        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat{
        get{
            return layer.shadowRadius
        }
        set{
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor?{
        
        get{
            if let color = layer.shadowColor{
                return UIColor(cgColor: color)
            }
            return nil
        }
        set{
            if let color = newValue {
                layer.masksToBounds = false
                layer.shadowColor = color.cgColor
            }else{
                layer.shadowColor = nil
            }
        }
    }
    
    func addShadow() {
        self.layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var underlineColour :UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    
    @IBInspectable var underLine : CGFloat {
        get {
            return 0.0
        }
        set {
            let border = CALayer()
            let width = CGFloat(newValue)
            border.borderColor = underlineColour?.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width +
                self.frame.size.height, height: self.frame.size.height)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var topCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable var bottomCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var rightCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable var leftCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}

//MARK:- TextField Extension
extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var leftPadding : CGFloat {
        get {
            return 0.0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var rightPadding : CGFloat {
        get {
            return 0.0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + self.frame.size.height, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

struct Constant {
    static let userDefault = UserDefaults.standard
    static var favouriteMeals : [Meals]?
}
