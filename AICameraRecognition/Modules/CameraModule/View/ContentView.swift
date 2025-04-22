//
//  ContentView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import SwiftUI

/// The main view that displays the live camera feed, detection overlays,
/// and recognized object titles in a horizontal scroll view. Also provides
/// a dismiss button to exit the camera view.
struct ContentView: View {
    
    // MARK: - Properties
    
    /// Holds the current set of detections published by the camera controller.
    @StateObject var detectionResults = DetectionResults()
    
    /// Identifier used for matched-geometry transitions when presenting/dismissing.
    private let transitionID: String
    /// Namespace for matched-geometry animations.
    private let animation: Namespace.ID
    /// Closure to be called when the user taps the dismiss button.
    private let onDismiss: () -> Void
    
    /// Initializes the content view.
    /// - Parameters:
    ///   - transitionID: A unique ID for transition animations.
    ///   - animation: The matched-geometry namespace.
    ///   - onDismiss: Closure invoked when the view should be dismissed.
    init(transitionID: String, animation: Namespace.ID, onDismiss: @escaping () -> Void) {
        self.animation = animation
        self.onDismiss = onDismiss
        self.transitionID = transitionID
    }
    
    // MARK: - Body
    
    internal var body: some View {
        ZStack {
            // Live camera preview underlays all other content
            CameraView(detectionResults: detectionResults)
                .ignoresSafeArea()
            
            // Draws bounding boxes and labels over the camera view
            DetectionOverlayView(detectionResults: detectionResults)
            
            // Scrollable list of recognized object titles at the top
            detectedTitlesScrollView
            // Dismisses button anchored at the bottom-right corner
            dismissButton
        }
        // Applies matched-geometry transition when navigating in/out
        .navigationTransition(
            id: transitionID,
            namespace: animation)
    }
    
    // MARK: - Subviews
    
    /// A horizontally scrolling view that displays the capitalized labels
    /// of all currently detected objects.
    private var detectedTitlesScrollView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(detectionResults.detections) { detection in
                    // Capitalizes the first letter of each detected label
                    let title = String(detection.label).capitalized
                    Text(title)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(Color.BackColors.backDefault)
                        .clipShape(.buttonBorder) // Rounded button shape
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .padding(.top)  // Pushes content below status bar or notch
        // Aligns content to the top-leading corner
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    /// A circular dismiss button positioned at the bottom-right corner,
    /// which invokes the provided `onDismiss` closure when tapped.
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
        // Aligns the button bottom-trailing corner
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}

// MARK: - Preview

#Preview {
    ContentView(transitionID: "Ids", animation: Namespace().wrappedValue) {
        // Provides a placeholder onDismiss closure for preview
    }
}
