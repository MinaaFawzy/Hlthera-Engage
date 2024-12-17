//
//  UiImageExt.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 09/12/2022.
//  Copyright © 2022 Fluper. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    
    
    func imageResize (sizeChange:CGSize)-> UIImage{

          let hasAlpha = true
          let scale: CGFloat = 0.0 // Use scale factor of main screen

          UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
          self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

          let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
          return scaledImage!
      }
    
    
    

}
