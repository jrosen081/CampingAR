//
//  CampingObjectView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/19/21.
//

import SwiftUI

struct CampingObjectView: View {
    @Binding var selectedObject: CampsiteObject?
    @Binding var shouldShowCustomization: Bool
    let allObjects = [CampsiteObject(iconName: "Fire-Unfilled", entityType: .campfire, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "Log-Unfilled", entityType: .wood, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .blue), CampsiteObject(iconName: "Tent-Unfilled", entityType: .tent(0), boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .orange), CampsiteObject(iconName: "Table-Unfilled", entityType: .table, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .red), CampsiteObject(iconName: "Chair-Unfilled", entityType: .chair, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "Cooler-Unfilled", entityType: .cooler, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "SleepingBag-Unfilled", entityType: .sleepingBag, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "Grill-Unfilled", entityType: .grill(1), boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green),CampsiteObject(iconName: "Bench-Unfilled", entityType: .bench, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green)]
    
    var body: some View {
        return ZStack {
            Color(hue: 0.244, saturation: 0.13, brightness: 0.84).frame(height:125)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(allObjects) { object in
                        Image(selectedObject?.id == object.id ? object.iconName.replacingOccurrences(of: "Unfilled", with: "Filled") : object.iconName).resizable().onDrag {
                            selectedObject = object
                            return NSItemProvider(item: nil, typeIdentifier: "my type")
                        }.frame(width: 100, height: 100, alignment: .center).padding(.leading, 3).padding(.trailing, 3)
                        .onTapGesture {
                            self.shouldShowCustomization = self.selectedObject?.id == object.id
                            self.selectedObject = object
                        }
                    }.padding(.bottom, 15)
                }.frame(height: 100)
            }.padding(.bottom, 15)
        }
    }
}
