//
//  ARViewContainer.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 2/1/23.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
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
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

// MARK: - Coordinator
extension ARViewContainer {
    
    final class Coordinator: NSObject {
        // MARK: - Properties
        weak var view: ARView?
        var cancellable: AnyCancellable?
        
        // MARK: - Delegate
        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let view = self.view else {
                return
            }
            
            guard view.scene.anchors.first(where: { $0.name == "LunarRoverAnchor" }) == nil else {
                return
            }
            
            let tapLocation = recognizer.location(in: view)
            
            let results = view.raycast(
                from: tapLocation,
                allowing: .estimatedPlane,
                alignment: .horizontal
            )
            
            guard let result = results.first else {
                return
            }
            
            // Create an anchor entity
            let anchor = AnchorEntity(raycastResult: result)
            anchor.name = "LunarRoverAnchor"
            
            // Load model entity
            cancellable = ModelEntity.loadAsync(named: "lunar-rover")                
                .sink { loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        fatalError("Unable to load the model. Detail: \(error)")
                    }
                    
                    self.cancellable?.cancel()
                } receiveValue: { entity in
                    anchor.addChild(entity)
                }
                                    
            // Add an anchor to the scene
            view.scene.addAnchor(anchor)
        }
        
    }
    
}
