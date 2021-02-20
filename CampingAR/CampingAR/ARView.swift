//
//  ARView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/19/21.
//

import ARKit
import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    @Binding var totalRayTraceHits: Int
    @Binding var dropLocation: CGPoint?
    @Binding var shouldShowMenu: Bool
    
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
        
        let arView = CustomARView(binding: self.$shouldShowMenu)
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
        Coordinator(totalHits: self.$totalRayTraceHits)
    }
    
    func becomeDroppable() -> some View {
        return self.onDrop(of: ["my type"], isTargeted: nil) { _, location in
            self.dropLocation = location
            return true
        }
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        guard let dropPoint = self.dropLocation else { return }
        let totalCount = ARViewInteractor(arView: uiView).addBox(location: dropPoint)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dropLocation = nil
            self.totalRayTraceHits = totalCount
        }
    }
}

class Coordinator {
    
    var arView: ARView? {
        didSet {
            arView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerTapped(_:))))
        }
    }
    
    let totalHits: Binding<Int>
    
    init(totalHits: Binding<Int>) {
        self.totalHits = totalHits
    }
    
    @objc func gestureRecognizerTapped(_ tapped: UITapGestureRecognizer) {
        addBox(location: tapped.location(in: arView))
    }
    
    func addBox(location tapLocation: CGPoint) {
        guard let arView = arView else { return }
        totalHits.wrappedValue = ARViewInteractor(arView: arView).addBox(location: tapLocation)
    }
}

struct ARViewInteractor: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        return addBox(location: info.location) > 0
    }
    
    let arView: ARView
    
    func addBox(location tapLocation: CGPoint) -> Int {
        let rayCast = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        rayCast.forEach { result in
            let box = MeshResource.generateBox(size: 0.3)
            let material = SimpleMaterial(color: .green, isMetallic: false)
            let entity = ModelEntity(mesh: box, materials: [material])
            entity.generateCollisionShapes(recursive: true)
            let anchor = AnchorEntity(raycastResult: result)
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)
            arView.installGestures([.rotation, .translation], for: entity)
        }
        return rayCast.count
    }
}

class CustomARView: ARView {
    let hasPlane: Binding<Bool>
    init(binding: Binding<Bool>) {
        self.hasPlane = binding
        super.init(frame: .zero)
    }
    
    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
}

extension CustomARView : ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        self.hasPlane.wrappedValue = false
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        self.hasPlane.wrappedValue = true
    }
}
