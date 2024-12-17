//
//  UiFonts.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 01/12/2022.
//  Copyright © 2022 Fluper. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    /// Font Work Sans Light
    ///
    /// - Parameter size: Font size you need
    /// - Returns: your custom font for custom size
    class func CorbenBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Corben-Bold", size: size)!
    }
    class func corbenRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Corben-Regular", size: size)!
    }
}
