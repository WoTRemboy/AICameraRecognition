//
//  ContentView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var detectionResults = DetectionResults()
    
    private let transitionID: String
    private let animation: Namespace.ID
    private let onDismiss: () -> Void
    
    init(transitionID: String, animation: Namespace.ID, onDismiss: @escaping () -> Void) {
        self.animation = animation
        self.onDismiss = onDismiss
        self.transitionID = transitionID
    }
    
    internal var body: some View {
        ZStack(alignment: .bottomTrailing) {
            CameraView(detectionResults: detectionResults)
                .ignoresSafeArea()
            
            DetectionOverlayView(detectionResults: detectionResults)
            
            dismissButton
        }
        .navigationTransition(
            id: transitionID,
            namespace: animation)
    }
    
    private var dismissButton: some View {
        Button {
            onDismiss()
        } label: {
            Image.CameraView.dismissButton
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
                .padding(20)
        }
    }
}

#Preview {
    ContentView(transitionID: "Ids", animation: Namespace().wrappedValue) {}
}
