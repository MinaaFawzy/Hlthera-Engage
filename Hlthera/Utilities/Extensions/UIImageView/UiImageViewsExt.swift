//
//  UiImageViewsExt.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 09/12/2022.
//  Copyright © 2022 Fluper. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
