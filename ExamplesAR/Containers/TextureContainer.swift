//
//  TextureContainer.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 3/1/23.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

struct TextureContainer: UIViewRepresentable {        
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        context.coordinator.arView = arView
        context.coordinator.setupAsyncMultipleImages()
        
        // Add Coaching View
        arView.addCoaching()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

// MARK: - Coordinator
extension TextureContainer {
    
    final class Coordinator {
        // MARK: - Properties
        unowned var arView: ARView?
        var cancellable: Cancellable?
        
        func setupSyncImage() {
            guard let arView = arView else {
                return
            }
            
            guard let imageURL = Bundle.main.url(forResource: "sonares-album", withExtension: "jpeg") else {
                fatalError("Image 'sonares-album' was not found!")
            }
            
            guard let texture = try? TextureResource.load(contentsOf: imageURL) else {
                fatalError("Error trying to load 'sonares-album' texture resource!")
            }
            
            let anchor = AnchorEntity(plane: .horizontal)
            let mesh = MeshResource.generateBox(size: 0.3)
            let box = ModelEntity(mesh: mesh)
            
            var material = UnlitMaterial()
            material.color = .init(tint: .white, texture: .init(texture))
            box.model?.materials = [material]
            
            anchor.addChild(box)
            arView.scene.addAnchor(anchor)
        }
        
        func setupAsyncMultipleImages() {
            guard let arView = arView else {
                return
            }
            
            let anchor = AnchorEntity(plane: .horizontal)
            let mesh = MeshResource.generateBox(
                width: 0.3,
                height: 0.3,
                depth: 0.3,
                cornerRadius: 0,
                splitFaces: true
            )
            let box = ModelEntity(mesh: mesh)
                        
            guard let sonaresAlbumImage = Bundle.main.url(forResource: "sonares-album", withExtension: "jpeg") else {
                fatalError("Error trying to load the image!")
            }
            
            guard let sonaresCardImage = Bundle.main.url(forResource: "sonares-vinyl-promo-card", withExtension: "jpeg") else {
                fatalError("Error trying to load the image!")
            }
            
            cancellable = TextureResource.loadAsync(contentsOf: sonaresAlbumImage) // Front
                .append(TextureResource.loadAsync(contentsOf: sonaresCardImage))   // Top
                .append(TextureResource.loadAsync(contentsOf: sonaresAlbumImage))  // Left
                .append(TextureResource.loadAsync(contentsOf: sonaresAlbumImage))  // Right
                .append(TextureResource.loadAsync(contentsOf: sonaresAlbumImage))  // Back
                .append(TextureResource.loadAsync(contentsOf: sonaresAlbumImage))  // Bottom
                .collect()
                .sink { [weak self] loadResponse in
                    if case let .failure(error) = loadResponse {
                        fatalError("Unable to load texture \(error)")
                    }
                    
                    self?.cancellable?.cancel()
                } receiveValue: { result in
                    var materials: [UnlitMaterial] = []
                    
                    result.forEach { texture in
                        var material = UnlitMaterial()
                        material.color = .init(tint: .white, texture: .init(texture))
                        
                        materials.append(material)
                    }
                    
                    box.model?.materials = materials
                    anchor.addChild(box)
                    arView.scene.addAnchor(anchor)
                }
            
        }
        
    }
    
}
