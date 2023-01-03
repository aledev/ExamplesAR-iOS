//
//  GravityContainer.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 3/1/23.
//

import SwiftUI
import RealityKit
import ARKit

struct GravityContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        let planeAnchorEntity = AnchorEntity(plane: .horizontal)
        
        let plane = ModelEntity(
            mesh: .generatePlane(width: 1.5, depth: 1),
            materials: [SimpleMaterial(color: .gray, isMetallic: true)]
        )
        
        plane.physicsBody = PhysicsBodyComponent(
            massProperties: .default,
            material: .generate(),
            mode: .static
        )
        plane.generateCollisionShapes(recursive: true)
        planeAnchorEntity.addChild(plane)
        
        arView.scene.anchors.append(planeAnchorEntity)
        
        arView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap)
            )
        )
        context.coordinator.view = arView
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
}

// MARK: - Coordinator
extension GravityContainer {
    
    final class Coordinator {
        // MARK: - Properties
        unowned var view: ARView?
        
        // MARK: - Delegate
        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let view = view else {
                return
            }

            let tapLocation = recognizer.location(in: view)
            let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
            
            guard let result = results.first else {
                return
            }
            
            let anchor = AnchorEntity(raycastResult: result)
            let box = ModelEntity(
                mesh: .generateBox(size: 0.3),
                materials: [
                    SimpleMaterial(color: .green, isMetallic: true)
                ]
            )
            box.physicsBody = PhysicsBodyComponent(
                massProperties: .default,
                material: .generate(),
                mode: .dynamic
            )
            box.generateCollisionShapes(recursive: true)
            box.position = simd_make_float3(0, 0.7, 0)
            
            anchor.addChild(box)
            view.scene.anchors.append(anchor)
        }
    }
    
}
