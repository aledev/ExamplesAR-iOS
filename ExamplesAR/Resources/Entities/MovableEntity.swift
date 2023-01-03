//
//  MovableEntity.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 3/1/23.
//

import Foundation
import RealityKit
import SwiftUI

// MARK: - ShapeType Enum
enum ShapeType {
    case box
    case sphere
}

// MARK: - MovableEntity Class
class MovableEntity: Entity, HasModel, HasPhysics, HasCollision {
    
    // MARK: - Properties
    var size: Float!
    var color: UIColor!
    var isMetallic: Bool!
    var shapeType: ShapeType = .box
    
    // MARK: - Initializers
    init(size: Float, color: UIColor, isMetallic: Bool, shapeType: ShapeType) {
        super.init()
        
        self.size = size
        self.color = color
        self.isMetallic = isMetallic
        self.shapeType = shapeType
        
        let mesh = generateMeshResource()
        let material = generateMaterial()
        let shape = generateShapeResource()
        
        model = ModelComponent(
            mesh: mesh,
            materials: [material]
        )
        
        physicsBody = PhysicsBodyComponent(
            massProperties: .default,
            material: .default,
            mode: .dynamic
        )
        
        collision = CollisionComponent(
            shapes: [shape],
            mode: .trigger,
            filter: .sensor
        )
        
        generateCollisionShapes(recursive: true)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}

// MARK: - Private Functions
extension MovableEntity {
    
    private func generateMeshResource() -> MeshResource {
        switch self.shapeType {
        case .box:
            return MeshResource.generateBox(size: size)
        case .sphere:
            return MeshResource.generateSphere(radius: size)
        }
    }
    
    private func generateMaterial() -> RealityKit.Material {
        SimpleMaterial(
            color: color,
            isMetallic: isMetallic
        )
    }
    
    private func generateShapeResource() -> ShapeResource {
        switch self.shapeType {
        case .box:
            return ShapeResource.generateBox(size: [size, size, size])
        case .sphere:
            return ShapeResource.generateSphere(radius: size)
        }
    }
    
}
