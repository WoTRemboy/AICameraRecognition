//
//  CameraView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/7/25.
//

import SwiftUI

/// A wrapper for `CameraViewController`, providing a live camera feed
/// and real-time object detection results within a SwiftUI view hierarchy.
struct CameraView: UIViewControllerRepresentable {
    
    /// An observable object that stores the latest detection results from the camera.
    @ObservedObject var detectionResults: DetectionResults
    
    /// Creates and configures the `CameraViewController` instance.
    ///
    /// - Parameter context: Context information provided by SwiftUI.
    /// - Returns: A fully initialized `CameraViewController` with its `detectionResults` set.
    internal func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.detectionResults = detectionResults
        return controller
    }
    
    /// Updates the `CameraViewController` when SwiftUI’s state changes.
    internal func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No dynamic updates
    }
}
