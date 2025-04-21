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
        ZStack {
            CameraView(detectionResults: detectionResults)
                .ignoresSafeArea()
            
            DetectionOverlayView(detectionResults: detectionResults)
            
            detectedTitlesScrollView
            dismissButton
        }
        .navigationTransition(
            id: transitionID,
            namespace: animation)
    }
    
    private var detectedTitlesScrollView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(detectionResults.detections) { detection in
                    let title = String(detection.label).capitalized
                    Text(title)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(Color.BackColors.backDefault)
                        .clipShape(.buttonBorder)
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}

#Preview {
    ContentView(transitionID: "Ids", animation: Namespace().wrappedValue) {}
}
