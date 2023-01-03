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

struct CollisionDetectionTwoContainer: UIViewRepresentable {        
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        
        context.coordinator.view = arView
        context.coordinator.buildEnvironment()
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
}

// MARK: - Coordinator
extension CollisionDetectionTwoContainer {
    
    final class Coordinator: NSObject, ARSessionDelegate, UIGestureRecognizerDelegate {
        // MARK: - Properties
        unowned var view: ARView?
        var movableEntities = [MovableEntity]()
        
        // MARK: - Functions
        func buildEnvironment() {
            guard let view = view else {
                return
            }
            
            let anchor = AnchorEntity(plane: .horizontal)
            
            // Floor
            let floor = ModelEntity(
                mesh: .generatePlane(width: 1, depth: 1),
                materials: [SimpleMaterial(color: .green, isMetallic: true)]
            )
            
            floor.generateCollisionShapes(recursive: true)
            floor.physicsBody = PhysicsBodyComponent(
                massProperties: .default,
                material: .default,
                mode: .static
            )
            
            anchor.addChild(floor)
            
            let entities: [MovableEntity] = [
                MovableEntity(size: 0.2, color: .red, isMetallic: true, shapeType: .box),
                MovableEntity(size: 0.2, color: .blue, isMetallic: true, shapeType: .box),
                MovableEntity(size: 0.2, color: .purple, isMetallic: true, shapeType: .sphere),
                MovableEntity(size: 0.2, color: .yellow, isMetallic: true, shapeType: .sphere)
            ]
            
            entities.forEach { entity in
                anchor.addChild(entity)
                movableEntities.append(entity)
                
                view.installGestures(.all, for: entity).forEach {
                    $0.delegate = self
                }
            }
            
            view.scene.anchors.append(anchor)
            setupGestures()
        }
        
        fileprivate func setupGestures() {
            guard let view = view else {
                return
            }
            
            let panGesture = UIPanGestureRecognizer(
                target: self,
                action: #selector(panned)
            )
            
            panGesture.delegate = self
            view.addGestureRecognizer(panGesture)
        }
        
        // MARK: - Delegates
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let translationGesture = gestureRecognizer as? EntityTranslationGestureRecognizer,
                  let entity = translationGesture.entity as? MovableEntity else {
                return true
            }
            
            entity.physicsBody?.mode = .kinematic
            
            return true
        }
        
        @objc func panned(_ sender: UIPanGestureRecognizer) {
            switch sender.state {
            case .ended, .cancelled, .failed:
                // Change the physics mode to dynamic
                movableEntities.compactMap { $0 }.forEach {
                    $0.physicsBody?.mode = .dynamic
                }
            default:
                return
            }
        }
    }
    
}
