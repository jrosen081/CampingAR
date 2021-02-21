//
//  CampingObjectView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/19/21.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct CampingObjectView: View {
    @Binding var selectedObject: CampsiteObject?
    @Binding var shouldShowCustomization: Bool
    let allObjects : [CampsiteObject]
    
    var body: some View {
        return ZStack {
            Color(hue: 0.244, saturation: 0.13, brightness: 0.84).frame(height:125)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(allObjects) { object in
                        Image(selectedObject?.id == object.id ? object.iconName.replacingOccurrences(of: "Unfilled", with: "Filled") : object.iconName).resizable().onDrag {
                            selectedObject = object
                            return NSItemProvider(item: nil, typeIdentifier: UTType.data.description)
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
