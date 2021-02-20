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
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    
//    static func makeBox(target: ARRaycastQuery.Target) {
//        let box = MeshResource.generateBox(size: 0.3)
//        let material = SimpleMaterial(color: .green, isMetallic: false)
//        let entity = ModelEntity(mesh: box, materials: [material])
//
//        let anchor = AnchorEntity(target)
//        anchor.addChild(entity)
//        return anchor
//    }
    
    func makeBox() -> HasAnchoring {
        let box = MeshResource.generateBox(size: 0.3)
        let material = SimpleMaterial(color: .green, isMetallic: false)
        let entity = ModelEntity(mesh: box, materials: [material])
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(entity)
        return anchor
    }
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addCoaching()
        context.coordinator.arView = arView
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        arView.scene.addAnchor(makeBox())
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        
        return arView
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    class Coordinator {
        var arView: ARView? {
            didSet {
                arView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerTapped(_:))))
            }
        }
        
        @objc func gestureRecognizerTapped(_ tapped: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            let tapLocation = tapped.location(in: arView)
            let rayCast = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
            rayCast.forEach { result in
                let box = MeshResource.generateBox(size: 0.3)
                let material = SimpleMaterial(color: .green, isMetallic: false)
                let entity = ModelEntity(mesh: box, materials: [material])
                let anchor = AnchorEntity(raycastResult: result)
                anchor.addChild(entity)
                arView.scene.addAnchor(anchor)
                arView.installGestures([.rotation, .scale], for: entity)
            }
        }
    }
    
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
