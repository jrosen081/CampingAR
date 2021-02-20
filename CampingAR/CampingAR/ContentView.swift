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
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ARViewContainer(totalRayTraceHits: self.$totalRayTraceHits, dropLocation: self.$dropLocation, shouldShowMenu: self.$shouldShowMenu)
                .becomeDroppable()
                .edgesIgnoringSafeArea(.all)
                .overlay(Text("Total hits: \(totalRayTraceHits)").padding(), alignment: .topTrailing)
            if shouldShowMenu {
                CampingObjectView()
            }
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
