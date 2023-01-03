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
import AVFoundation

struct VideoContainer: UIViewRepresentable {
        
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.name = "VideoPlayerAnchor"
        
        guard let videoURL = Bundle.main.url(forResource: "el-mundo-promo", withExtension: "mp4") else {
            fatalError("Video file was not found!")
        }
        
        let player = AVPlayer(url: videoURL)
        let material = VideoMaterial(avPlayer: player)
        material.controller.audioInputMode = .spatial
        
        let modelEntity = ModelEntity(
            mesh: .generatePlane(width: 0.5, depth: 0.5),
            materials: [material]
        )
        modelEntity.name = "VideoPlayerMaterial"
        
        arView.installGestures(.all, for: modelEntity)
        arView.addGestureRecognizer(
            UIGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap)
            )
        )        
        context.coordinator.view = arView
        
        anchor.addChild(modelEntity)
        arView.scene.addAnchor(anchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
 
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

// MARK: - Coordinator
extension VideoContainer {
    
    final class Coordinator: NSObject, ARSessionDelegate {
        // MARK: - Properties
        unowned var view: ARView?
        
        // MARK: - Delegate
        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            print("handle TAP!")
            
            guard let view = view else {
                debugPrint("view is nil!")
                return
            }
            
            let tapLocation = recognizer.location(in: view)
            
            debugPrint("Tap Location:")
            debugPrint(tapLocation)
            
            guard let hitEntity = view.entity(at: tapLocation) as? ModelEntity else {
                debugPrint("Hit Entity error!")
                return
            }
            
            debugPrint(hitEntity)
            
            guard let videoMaterial = hitEntity.model?.materials.first(where: { $0 is VideoMaterial }) as? VideoMaterial else {
                debugPrint("Video Material error!")
                return
            }
            
            videoMaterial.avPlayer?.play()
        }
        
    }
    
}
