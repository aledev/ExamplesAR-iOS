//
//  ContentView.swift
//  HelloAR
//
//  Created by Alejandro Ignacio Aliaga Martinez on 30/12/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    var body: some View {
        
//        ARViewContainer()
//            .edgesIgnoringSafeArea(.all)
        
//        OcclusionContainer()
//            .edgesIgnoringSafeArea(.all)
        
//        VideoContainer()
//            .edgesIgnoringSafeArea(.all)
        
//        UnlitContainer()
//            .edgesIgnoringSafeArea(.all)
        
        TextureContainer()
            .edgesIgnoringSafeArea(.all)
//
//        GravityContainer()
//            .edgesIgnoringSafeArea(.all)
        
//        CollisionDetectionContainer()
//            .edgesIgnoringSafeArea(.all)
        
//        CollisionDetectionTwoContainer()
//            .edgesIgnoringSafeArea(.all)
//
//        CoachingOverlayContainer()
//            .edgesIgnoringSafeArea(.all)
        
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
