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
    @State var shouldTakeScreenshot = false
    @State var selectEntity: Entity? = nil
    
    let allOptions = Dictionary(uniqueKeysWithValues: (0..<100).map { ("fire\($0)", CampsiteObject(iconName: "Fire-Filled", entityType: .campfire, boundingBox: BoundingBox(height: 10, width: 20, length: 10), color: .green)) })
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .topTrailing) {
                ARViewContainer(totalRayTraceHits: self.$totalRayTraceHits, dropLocation: self.$dropLocation, shouldShowMenu: self.$shouldShowMenu, selectedObject: self.$selectedObject, shouldTakeScreenshot: self.$shouldTakeScreenshot, selectedEntity: self.$selectEntity)
                    .becomeDroppable()
                    .edgesIgnoringSafeArea(.all)
                if self.selectEntity != nil {
                    Button(action: {
                        var selectedEntity = self.selectEntity;
                        while (selectedEntity?.parent != nil) {
                            selectedEntity = selectedEntity?.parent
                        }
                        selectedEntity?.removeFromParent()
                        self.selectEntity = nil
                    }, label: {
                        Text("Delete")
                    }).padding()
                    .background(Color(hue: 0.244, saturation: 0.13, brightness: 0.84))
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(.black)
                }
            }
            if shouldShowMenu || UIDevice.current.userInterfaceIdiom == .pad {
                VStack {
                    ScreenshotButtonView(shouldTakeScreenshot: self.$shouldTakeScreenshot)
                    CampingObjectView(selectedObject: self.$selectedObject, shouldShowCustomization: self.$isShowingCustomization)
                }
            }
        }.edgesIgnoringSafeArea(.bottom).sheet(isPresented: self.$isShowingCustomization) {
            CustomizationView(selectedObject: self.$selectedObject, allOptions: allOptions)
        }
    }
}
