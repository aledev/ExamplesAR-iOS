//
//  ARView+Extension.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 3/1/23.
//

import ARKit
import RealityKit

extension ARView: ARCoachingOverlayViewDelegate {
    
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(coachingOverlay)
        
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
        coachingOverlay.setActive(true, animated: true)
    }
    
    private func addVirtualObjects() {
        let box = ModelEntity(
            mesh: .generateBox(size: 0.3),
            materials: [SimpleMaterial(color: .green, isMetallic: true)]
        )
        
        guard let anchor = self.scene.anchors.first(where: { $0.name == "Plane Anchor" }) else {
            return
        }
        
        anchor.addChild(box)
    }
    
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        debugPrint("Coaching Overlay View Will Activate!")
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        addVirtualObjects()
    }
    
}
