//
//  CampingModel.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/20/21.
//

import Foundation
import SwiftUI

struct CampsiteObject: Identifiable {
    let iconName: String
    let entityName: String
    let boundingBox: BoundingBox
    let color: Color
    let id = UUID()
}

struct BoundingBox {
    let height: Double
    let width: Double
    let length: Double
}
