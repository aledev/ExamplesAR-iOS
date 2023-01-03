//
//  GravityContainer.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 3/1/23.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct CollisionDetectionContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        let floorAnchorEntity = AnchorEntity(plane: .horizontal)
        let floor = ModelEntity(
            mesh: .generateBox(size: [1000, 0, 1000]),
            materials: [
                OcclusionMaterial()
            ]
        )
        
        floor.generateCollisionShapes(recursive: true)
        floor.physicsBody = PhysicsBodyComponent(
            massProperties: .default,
            material: .generate(),
            mode: .static
        )
        
        floorAnchorEntity.addChild(floor)
        
        arView.scene.anchors.append(floorAnchorEntity)
        arView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap)
            )
        )
        
        context.coordinator.view = arView
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
}

// MARK: - Coordinator
extension CollisionDetectionContainer {
    
    final class Coordinator: NSObject, ARSessionDelegate {
        // MARK: - Properties
        unowned var view: ARView?
        var collisionSubscriptions = [Cancellable]()
        
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
                mesh: .generateBox(size: 0.2),
                materials: [
                    SimpleMaterial(color: .green, isMetallic: true)
                ]
            )
            box.generateCollisionShapes(recursive: true)
            box.position.y = 0.3
            box.physicsBody = PhysicsBodyComponent(
                massProperties: .default,
                material: .default,
                mode: .dynamic
            )
            box.collision = CollisionComponent(
                shapes: [
                    .generateBox(size: simd_float3(0.2, 0.2, 0.2))
                ],
                mode: .trigger,
                filter: .sensor
            )
            
            collisionSubscriptions.append(
                view.scene.subscribe(to: CollisionEvents.Began.self) { event in
                    box.model?.materials = [SimpleMaterial(color: .purple, isMetallic: true)]
                }
            )
            
            collisionSubscriptions.append(
                view.scene.subscribe(to: CollisionEvents.Ended.self) { event in
                    box.model?.materials = [SimpleMaterial(color: .green, isMetallic: true)]
                }
            )
            
            anchor.addChild(box)
            view.scene.anchors.append(anchor)
        }
    }
    
}
