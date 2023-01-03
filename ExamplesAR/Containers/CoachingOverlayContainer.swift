//
//  CoachingOverlayContainer.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 3/1/23.
//

import SwiftUI
import RealityKit
import ARKit

struct CoachingOverlayContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.name = "Plane Anchor"                
        arView.scene.addAnchor(anchor)
        arView.addCoaching()
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
}
