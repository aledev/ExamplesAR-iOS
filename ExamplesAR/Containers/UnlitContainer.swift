//
//  UnlitContainer.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 3/1/23.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit

struct UnlitContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal)
        let box = ModelEntity(
            mesh: .generateBox(size: 0.3),
            materials: [                
                UnlitMaterial(color: .red)
            ]
        )
        
        anchor.addChild(box)
        arView.scene.addAnchor(anchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
