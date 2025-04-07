//
//  ContentView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var detectionResults = DetectionResults()
    
    var body: some View {
        ZStack {
            CameraView(detectionResults: detectionResults)
                .ignoresSafeArea()
            
            DetectionOverlayView(detectionResults: detectionResults)
        }
    }
}

#Preview {
    ContentView()
}
