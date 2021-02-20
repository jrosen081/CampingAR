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
    var body: some View {
        VStack {
            ARViewContainer(totalRayTraceHits: self.$totalRayTraceHits, dropLocation: self.$dropLocation)
                .becomeDroppable()
                .edgesIgnoringSafeArea(.all)
                .overlay(Text("Total hits: \(totalRayTraceHits)").padding(), alignment: .bottomTrailing)
            CampingObjectView()
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
