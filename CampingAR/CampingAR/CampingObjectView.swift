//
//  CampingObjectView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/19/21.
//

import SwiftUI

struct CampingObjectView: View {
    let allObjects = [CampsiteObject(iconName: "Fire-Filled", entityName: "fire", boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "Log-Filled", entityName: "log", boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .blue), CampsiteObject(iconName: "Tent-Filled", entityName: "tent", boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .orange), CampsiteObject(iconName: "Table-Filled", entityName: "table", boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .red)]
    
    var body: some View {
        ZStack {
            Color(hue: 0.244, saturation: 0.13, brightness: 0.84).frame(height:125)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(allObjects) { object in
                        Image(object.iconName).resizable().onDrag {
                            return NSItemProvider(item: nil, typeIdentifier: "my type")
                        }.frame(width: 100, height: 100, alignment: .center).padding(.leading, 3).padding(.trailing, 3)
                            
                    }.padding(.bottom, 15)
                }.frame(height: 100)
            }.padding(.bottom, 15)

        }
    }
}

extension Int: Identifiable {
    public var id: Self {
        return self
    }
}

struct CampingObjectView_Previews: PreviewProvider {
    static var previews: some View {
        CampingObjectView()
    }
}
