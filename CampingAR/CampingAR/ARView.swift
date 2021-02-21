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
    @Binding var selectedObject: CampsiteObject?

    
    func makeUIView(context: Context) -> ARView {
        
        let arView = CustomARView(binding: self.$shouldShowMenu)
        arView.addCoaching()
        context.coordinator.arView = arView
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.frameSemantics.insert(.personSegmentationWithDepth)
        arView.session.run(config, options: [])
        
        return arView
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(totalHits: self.$totalRayTraceHits, selectedObject: self.$selectedObject)
    }
    
    func becomeDroppable() -> some View {
        return self.onDrop(of: ["my type"], isTargeted: nil) { _, location in
            self.dropLocation = location
            return true
        }
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        guard let dropPoint = self.dropLocation else { return }
        context.coordinator.addEntity(location: dropPoint)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dropLocation = nil
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
    let selectedObject: Binding<CampsiteObject?>
    
    init(totalHits: Binding<Int>, selectedObject: Binding<CampsiteObject?>) {
        self.totalHits = totalHits
        self.selectedObject = selectedObject
    }
    
    @objc func gestureRecognizerTapped(_ tapped: UITapGestureRecognizer) {
        addEntity(location: tapped.location(in: arView))
    }
    

    func addEntity(location tapLocation: CGPoint) {
        guard let arView = arView, let selectedObject = self.selectedObject.wrappedValue else { return }
        ARViewInteractor(arView: arView).addEntity(location: tapLocation, anchor: selectedObject.entityType.anchor)
    }
}

struct ARViewInteractor {
    
    let arView: ARView
    func addEntity(location tapLocation: CGPoint, anchor: HasAnchoring & CustomAnchor) {
        guard let entity = anchor.collisionEntity else { return}
    let rayCast = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
    entity.generateCollisionShapes(recursive: true)
    guard let result = rayCast.first else {return}
    anchor.transform  = AnchorEntity(raycastResult: result).transform
    arView.scene.addAnchor(anchor)
    arView.installGestures([.rotation, .translation], for: entity)
    anchor.addChild(entity)
    let _ = arView.trackedRaycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal, updateHandler: { results in
            guard let result = results.first else { return }
            let anchorTemp = AnchorEntity(raycastResult: result)
        anchor.transform = anchorTemp.transform
        })
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
