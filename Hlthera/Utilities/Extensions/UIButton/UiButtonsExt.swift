//
//  UiButtonsExt.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 09/12/2022.
//  Copyright © 2022 Fluper. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    func leftImage(image: UIImage,
                   renderMode: UIImage.RenderingMode,
                   paddingTop: CGFloat,
                   paddingLeft: CGFloat,
                   paddingRight: CGFloat,
                   paddingBottom: CGFloat
    ) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right:paddingRight)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
//        self.imageView?.contentMode = .scaleToFill

    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}
