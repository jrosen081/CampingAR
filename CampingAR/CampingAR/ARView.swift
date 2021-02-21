//
//  ARView.swift
//  CampingAR
//
//  Created by Jack Rosen on 2/19/21.
//

import ARKit
import RealityKit
import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct ARViewContainer: UIViewRepresentable {
    @Binding var totalRayTraceHits: Int
    @Binding var dropLocation: CGPoint?
    @Binding var shouldShowMenu: Bool
    @Binding var selectedObject: CampsiteObject?
    @Binding var shouldTakeScreenshot: Bool
    @Binding var selectedEntity: Entity?
    
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
        Coordinator(totalHits: self.$totalRayTraceHits, selectedObject: self.$selectedObject, selectedEntity: self.$selectedEntity)
    }
    
    func becomeDroppable() -> some View {
        return self.onDrop(of: [UTType.data.description], isTargeted: nil) { _, location in
            print("I am dropping")
            self.dropLocation = location
            return true
        }
    }
    
    func takeScreenshot(_ uiView: ARView) {
        uiView.doScreenshot(callback: {
            (img: UIImage?) -> Void in
            let viewController = UIApplication.shared.windows.first!.rootViewController
            let items = [img!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
                return
            }
            viewController!.present(ac, animated: true)
        })
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if self.shouldTakeScreenshot {
            self.takeScreenshot(uiView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.shouldTakeScreenshot = false
            }
        }
        
        guard let dropPoint = self.dropLocation else { return }
        context.coordinator.addEntity(location: dropPoint, selectedObject: self.selectedObject)
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
    let selectedEntity: Binding<Entity?>
    
    init(totalHits: Binding<Int>, selectedObject: Binding<CampsiteObject?>, selectedEntity: Binding<Entity?>) {
        self.totalHits = totalHits
        self.selectedObject = selectedObject
        self.selectedEntity = selectedEntity
    }
    
    @objc func gestureRecognizerTapped(_ tapped: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        ARViewInteractor(arView: arView).selectEntity(location: tapped.location(in: arView), entity: self.selectedEntity)
        
    }
    

    func addEntity(location tapLocation: CGPoint, selectedObject: CampsiteObject?) {
        guard let arView = arView, let selectedObject = selectedObject else { return }
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
        anchor.transform = AnchorEntity(raycastResult: result).transform
        arView.scene.addAnchor(anchor)
        arView.installGestures([.rotation, .translation], for: entity)
        anchor.addChild(entity)
        let _ = arView.trackedRaycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal, updateHandler: { results in
                guard let result = results.first else { return }
                let anchorTemp = AnchorEntity(raycastResult: result)
            anchor.transform = anchorTemp.transform
            })
    }
    
    func selectEntity(location tapLocation: CGPoint, entity: Binding<Entity?>) {
        entity.wrappedValue = arView.entity(at: tapLocation)
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

extension ARView {
    func doScreenshot(callback: @escaping (UIImage?) -> Void) {
        self.snapshot(saveToHDR: false, completion: {
            (img: ARView.Image?) -> Void in
            callback(img)
        })
    }
}
