//
//  UITextFieldExtension.swift
//  Shopiroller
//
//  Created by Görkem Gür on 8.11.2021.
//

import Foundation
import UIKit


extension UITextField {
    
    func setBottomBorderOnlyWith(color: CGColor) {
        self.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(0.5)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.yellow.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")
        
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
    
    func showErrorView(message: String) {
        
        
        let messageVw = UIView(frame: CGRect(x: self.frame.origin.x, y: self.frame.maxY - 2, width: self.frame.width, height: 30))
        messageVw.backgroundColor = UIColor.red
        
        let errorMessage = UILabel()
        errorMessage.autoresizesSubviews = false
        errorMessage.text = message
        errorMessage.textColor = .red
        errorMessage.isHidden = true
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 10.0)
        ])
        messageVw.addSubview(errorMessage)
        
        
        
        self.addSubview(messageVw)
    }
    
    var rightViewImage: UIImage? {
        set {
            let button = UIButton(type: .custom)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            button.frame = CGRect(x: 0.0, y: 0.0, width: 80, height: bounds.size.height)
            button.setImage(newValue)
            self.rightView = button
            self.rightViewMode = .always
            
            translatesAutoresizingMaskIntoConstraints = false
            rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }
        get {
            return (rightView as? UIImageView)?.image
        }
    }
}