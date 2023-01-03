//
//  OcclussionContainer.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 2/1/23.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit
import Combine

struct OcclusionContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        
        context.coordinator.arView = arView
        context.coordinator.setup()
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

// MARK: - Coordinator
extension OcclusionContainer {
    
    final class Coordinator {
        // MARK: - Properties
        var arView: ARView?
        var cancellable: AnyCancellable?
        
        func setup() {
            guard let arView = arView else {
                return
            }
            
            let anchor = AnchorEntity(plane: .horizontal)
            let box = ModelEntity(
                mesh: .generateBox(size: 0.3),
                materials: [OcclusionMaterial(receivesDynamicLighting: true)]
            )
            box.generateCollisionShapes(recursive: true)
            arView.installGestures(.all, for: box)
            
            cancellable = ModelEntity.loadAsync(named: "toy-drummer")
                .sink { [weak self] completion in
                    if case let .failure(error) = completion {
                        fatalError("Unable to load model. Detail: \(error)")
                    }
                    
                    self?.cancellable?.cancel()
                } receiveValue: { entity in
                    anchor.addChild(entity)
                }
            
            anchor.addChild(box)
            arView.scene.addAnchor(anchor)
        }
        
    }
    
}
