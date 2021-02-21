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
    @State var selectedIndex: Int?
    var selectedObjectBinding: Binding<CampsiteObject?> {
        Binding(get: {
            selectedIndex.map { allObjects[$0] }
        }, set: { value in
            if let value = value, let selectedIndex = allObjects.firstIndex(where: { $0.id == value.id }) ?? selectedIndex {
                self.selectedIndex = selectedIndex
                allObjects[selectedIndex] = value
            } else {
                selectedIndex = nil
            }
        })
    }
    var selectedObject: CampsiteObject? {
        get {
            return selectedObjectBinding.wrappedValue
        }
        set {
            selectedObjectBinding.wrappedValue = newValue
        }
    }
    @State var isShowingCustomization = false
    @State var shouldTakeScreenshot = false
    @State var selectEntity: Entity? = nil
    @State var allObjects = [CampsiteObject(iconName: "Fire-Unfilled", entityType: .campfire, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "Log-Unfilled", entityType: .wood, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .blue), CampsiteObject(iconName: "Tent-Unfilled", entityType: .tent(1), boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .orange), CampsiteObject(iconName: "Table-Unfilled", entityType: .table, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .red), CampsiteObject(iconName: "Chair-Unfilled", entityType: .chair, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "Cooler-Unfilled", entityType: .cooler, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "SleepingBag-Unfilled", entityType: .sleepingBag, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green), CampsiteObject(iconName: "Grill-Unfilled", entityType: .grill(1), boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green),CampsiteObject(iconName: "Bench-Unfilled", entityType: .bench, boundingBox: BoundingBox(height: 10, width: 10, length: 10), color: .green)]
    
    
    
    
//    let allOptions = Dictionary(uniqueKeysWithValues: (0..<100).map { ("fire\($0)", CampsiteObject(iconName: "Fire-Filled", entityType: .campfire, boundingBox: BoundingBox(height: 10, width: 20, length: 10), color: .green)) })
    let allOptions: [EntityType: [String: CampsiteObject]] = [
        .bench: ["small": CampsiteObject(iconName: "Tent-Unfilled", entityType: .bench, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                 "medium": CampsiteObject(iconName: "Tent-Unfilled", entityType: .bench, boundingBox: BoundingBox(height: 1, width: 2.25, length: 1.25), color: .green),
                 "large": CampsiteObject(iconName: "Tent-Unfilled", entityType: .bench, boundingBox: BoundingBox(height: 1.25, width: 2.33, length: 1.33), color: .green),],
        .campfire: ["small": CampsiteObject(iconName: "Fire-Unfilled", entityType: .campfire, boundingBox: BoundingBox(height: 0.8, width: 0.45, length: 0.45), color: .green),
                    "medium": CampsiteObject(iconName: "Fire-Unfilled", entityType: .campfire, boundingBox: BoundingBox(height: 0.9, width: 0.55, length: 0.55), color: .green),
                    "large": CampsiteObject(iconName: "Fire-Unfilled", entityType: .campfire, boundingBox: BoundingBox(height: 1, width: 0.75, length: 0.75), color: .green)],
        .chair: [:],
        .cooler: ["small": CampsiteObject(iconName: "Cooler-Unfilled", entityType: .cooler, boundingBox: BoundingBox(height: 0.5, width: 0.5, length: 0.25), color: .green),
                  "medium": CampsiteObject(iconName: "Cooler-Unfilled", entityType: .cooler, boundingBox: BoundingBox(height: 0.67, width: 0.67, length: 0.33), color: .green),
                  "large": CampsiteObject(iconName: "Cooler-Unfilled", entityType: .cooler, boundingBox: BoundingBox(height: 0.75, width: 0.75, length: 0.5), color: .green)],
        .grill(0): ["Grill 1": CampsiteObject(iconName: "Grill-Unfilled", entityType: .grill(0), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                    "Grill 2": CampsiteObject(iconName: "Grill-Unfilled", entityType: .grill(1), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green)],
        .grill(1): ["Grill 1": CampsiteObject(iconName: "Grill-Unfilled", entityType: .grill(0), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                    "Grill 2": CampsiteObject(iconName: "Grill-Unfilled", entityType: .grill(1), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green)],
        .sleepingBag: ["small": CampsiteObject(iconName: "SleepingBag-Unfilled", entityType: .sleepingBag, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                       "medium": CampsiteObject(iconName: "SleepingBag-Unfilled", entityType: .sleepingBag, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                       "large": CampsiteObject(iconName: "SleepingBag-Unfilled", entityType: .sleepingBag, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green)],
        .table: ["small": CampsiteObject(iconName: "Table-Unfilled", entityType: .table, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                 "medium": CampsiteObject(iconName: "Table-Unfilled", entityType: .table, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                 "large": CampsiteObject(iconName: "Table-Unfilled", entityType: .table, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green)],
        .tent(0): ["Tent 1": CampsiteObject(iconName: "Tent-Unfilled", entityType: .tent(0), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                   "Tent 2": CampsiteObject(iconName: "Tent-Unfilled", entityType: .tent(1), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green)],
        .tent(1): ["Tent 1": CampsiteObject(iconName: "Tent-Unfilled", entityType: .tent(0), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                   "Tent 2": CampsiteObject(iconName: "Tent-Unfilled", entityType: .tent(1), boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green)],
        .wood: ["small": CampsiteObject(iconName: "Log-Unfilled", entityType: .wood, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                "medium": CampsiteObject(iconName: "Log-Unfilled", entityType: .wood, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green),
                "large": CampsiteObject(iconName: "Log-Unfilled", entityType: .wood, boundingBox: BoundingBox(height: 0.75, width: 2, length: 1), color: .green)]
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .topTrailing) {
                ARViewContainer(totalRayTraceHits: self.$totalRayTraceHits, dropLocation: self.$dropLocation, shouldShowMenu: self.$shouldShowMenu, selectedObject: self.selectedObjectBinding, shouldTakeScreenshot: self.$shouldTakeScreenshot, selectedEntity: self.$selectEntity)
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
                    CampingObjectView(selectedObject: self.selectedObjectBinding, shouldShowCustomization: self.$isShowingCustomization, allObjects: allObjects)
                }
            }
        }.edgesIgnoringSafeArea(.bottom).sheet(isPresented: self.$isShowingCustomization) {
            CustomizationView(selectedObject: self.selectedObjectBinding, isOpen: self.$isShowingCustomization, allOptions: allOptions[selectedObject!.entityType]!)
        }
    }
}
