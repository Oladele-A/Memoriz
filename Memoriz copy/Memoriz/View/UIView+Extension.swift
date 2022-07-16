//
//  UIView+Extension.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/6/22.
//

import Foundation
import UIKit

extension UIView{
   @IBInspectable var cornerRadius:CGFloat{
        get{return cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
