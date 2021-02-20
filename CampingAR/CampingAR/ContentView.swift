//
//  ContentView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/19/21.
//

import ARKit
import SwiftUI
import RealityKit

struct ContentView : View {
    @State var totalRayTraceHits = 0
    @State var dropLocation: CGPoint? = nil
    @State var shouldShowMenu = false
    @State var selectedObject: CampsiteObject? = nil
    @State var isShowingCustomization = false
    let allOptions = ["fire1": CampsiteObject(iconName: "Fire-Filled", entityName: "", boundingBox: BoundingBox(height: 10, width: 20, length: 10), color: .gray), "fire2": CampsiteObject(iconName: "Fire-Unfilled", entityName: "ugh", boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .gray)]
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .bottomTrailing) {
                ARViewContainer(totalRayTraceHits: self.$totalRayTraceHits, dropLocation: self.$dropLocation, shouldShowMenu: self.$shouldShowMenu)
                    .becomeDroppable()
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Text("Total hits: \(totalRayTraceHits)").padding(), alignment: .topTrailing)
                if shouldShowMenu {
                    HStack {
                        CampingObjectView()
                        Button {
                            self.isShowingCustomization = true
                        } label: {
                            Text("Test")
                        }
                    }
                    
                }
            }
            if let object = selectedObject {
                Image(object.iconName).frame(width: 100, height: 100)
            }
        }.edgesIgnoringSafeArea(.bottom).sheet(isPresented: self.$isShowingCustomization) {
            CustomizationView(selectedObject: self.$selectedObject, allOptions: allOptions)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
