//
//  CameraView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/7/25.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var detectionResults: DetectionResults
    
    internal func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.detectionResults = detectionResults
        return controller
    }
    
    internal func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
