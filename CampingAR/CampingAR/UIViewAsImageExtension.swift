//
//  UIViewAsImageExtension.swift
//  CampingAR
//
//  Created by Samuel Xifaras on 2/20/21.
//

import Foundation
import SwiftUI

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
